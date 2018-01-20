#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <unistd.h>
#include <signal.h>
#include <limits.h>
#include <time.h>
#include <getopt.h>
#include <assert.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>

#include "setproctitle.h"

#define PROGRAM_NAME                        "ela-bootstrapd"

#define ELASTOS_BOOTSTRAP_VERSION           "5.0"
#define ELASTOS_BOOTSTRAP_BUILD_NUMBER      20171203UL

static const char *bootstrap_config_files[] = {
    "./bootstrapd.conf",
    "/etc/elastos/bootstrapd.conf",
    "/usr/local/etc/elastos/bootstrapd.conf",
    NULL
};

static bool run_in_foreground = false;

static const char *get_config_file(const char *config, 
        const char *candidates[])
{
    const char **cond;

    if (config && *config)
        return config;

    for (cond = candidates; *cond; cond++) {
        int fd = open(*cond, O_RDONLY);
        if (fd < 0)
            continue;

        close(fd);
        return *cond;
    }

    return NULL;
}

int turn_main(int argc, char *argv[]);

static uint8_t bootstrap_secret_key[32];

void bootstrap_get_secret_key(uint8_t *secret_key)
{
    memcpy(secret_key, bootstrap_secret_key, sizeof(bootstrap_secret_key));
}

pid_t start_turn_server(int port, const char *realm, const char *pid_file, 
                        const char *userdb, int verbose, uint8_t *secret_key)
{
    pid_t pid;

    memcpy(bootstrap_secret_key, secret_key, sizeof(bootstrap_secret_key));

    pid = fork();
    if (pid < 0)
        return -1;

    if (pid == 0) {
        char port_str[32];
        char pid_arg[PATH_MAX];
        int nargs = 0;
        char *args[32];
        int rc;

        //setproctitle("Elastos-Bootstrap-TURN");

        args[nargs++] = (char *)PROGRAM_NAME;
        args[nargs++] = (char *)"-n";
        args[nargs++] = (char *)"-a";

        if (port > 0) {
            sprintf(port_str, "%d", port);
            args[nargs++] = (char *)"-p";
            args[nargs++] = port_str;
        }

        if (realm) {
            args[nargs++] = (char *)"-r";
            args[nargs++] = (char *)realm;
        }

        if (pid_file) {
            sprintf(pid_arg, "--pidfile=%s", pid_file);
            args[nargs++] = pid_arg;
        }

        if (userdb) {
            args[nargs++] = (char *)"-b";
            args[nargs++] = (char *)userdb;
        }

        if (verbose)
            args[nargs++] = (char *)"-v";

        if (run_in_foreground) {
            args[nargs++] = (char *)"--log-file=stdout";
        } else {
            args[nargs++] = (char *)"--no-stdout-log";
            args[nargs++] = (char *)"--syslog";
        }


        args[nargs++] = (char *)"--no-tcp";
        args[nargs++] = (char *)"--no-tls";
        args[nargs++] = (char *)"--no-dtls";
        args[nargs++] = (char *)"--no-tcp-relay";
        args[nargs++] = (char *)"--syslog";

        //optreset = 1;  //Not supported on Linux
        opterr = 1;
        optind = 1;
        optopt = '?';
        optarg = NULL;   

        rc = turn_main(nargs, args);
        exit(rc);
    }

    return pid;
}

int tox_bootstrap_main(int argc, char *argv[]);

static bool terminating = false;

static void terminate(int sig)
{
    if (terminating)
        return;

    terminating = true;
    kill(0, SIGTERM);

    exit(0);
}

static void print_help(void)
{
    printf(
        "Usage: ela-bootstrapd [OPTION]...\n"
        "\n"
        "Options:\n"
        "  --config=FILE                Specify path to the TURN config file.\n"
        "  --foreground                 Run the daemon in foreground.\n"
        "  --version                    Print version information.\n"
        "  --help                       Print this help message.\n");
}

int main(int argc, char *argv[])
{
    const char *bootstrap_config = NULL;
    char config_arg[PATH_MAX];
    char *args[8];
    int nargs = 0;
    int rc;

    static struct option long_options[] = {
        {"config",                  required_argument, 0, 'c'}, 
        {"foreground",              no_argument,       0, 'f'},
        {"help",                    no_argument,       0, 'h'},
        {"version",                 no_argument,       0, 'v'},
        {0,                         0,                 0,  0 }
    };

    int opt;

    printf("Elastos bootstrap daemon, version %s(%lu)\n",
            ELASTOS_BOOTSTRAP_VERSION, ELASTOS_BOOTSTRAP_BUILD_NUMBER);

    while ((opt = getopt_long(argc, argv, "c:fhv", long_options, NULL)) != -1) {
        switch (opt) {
            case 'c':
                bootstrap_config = optarg;
                break;

            case 'f':
                run_in_foreground = true;
                break;

            case 'h':
                print_help();
                exit(0);

            case 'v':
                printf("Version: %s(%lu)\n", ELASTOS_BOOTSTRAP_VERSION, 
                        ELASTOS_BOOTSTRAP_BUILD_NUMBER);
                exit(0);

            case '?':
                print_help();
                exit(1);

            case ':':
                printf("Error: No argument provided for option %s\n\n", 
                        argv[optind - 1]);
                print_help();
                exit(1);
        }
    }
/*
    printf("\n========================================================\n");
    printf("Process %d waiting for debugger attach......\n", getpid());
    printf("========================================================\n");
    getchar();
    getchar();
*/
    bootstrap_config = get_config_file(bootstrap_config, bootstrap_config_files);
    if (bootstrap_config == NULL) {
        printf("No required bootstrap config file specified.\n\n");
        print_help();
        return -1;
    }

    //spt_init(argc, argv);
    //setproctitle("Elastos-Bootstrap-Main");

    signal(SIGHUP, terminate);
    signal(SIGINT, terminate);
    signal(SIGCHLD, terminate);
    signal(SIGTERM, terminate);

    //optreset = 1;  //Not supported on Linux
    opterr = 1;
    optind = 1;
    optopt = '?';
    optarg = NULL;   

    args[nargs++] = (char *)PROGRAM_NAME;

    sprintf(config_arg, "--config=%s", bootstrap_config);
    args[nargs++] = config_arg;

    if (run_in_foreground) {
        args[nargs++] = (char *)"--foreground";
        args[nargs++] = (char *)"--log-backend=stdout";
    } else {
        args[nargs++] = (char *)"--log-backend=syslog";
    }

    rc = tox_bootstrap_main(nargs, args);

    terminate(0);

    return rc;
}
