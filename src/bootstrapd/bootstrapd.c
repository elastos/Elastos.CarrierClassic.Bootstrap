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

static const char *turn_server_config_files[] = {
    "./turnserver.conf",
    "/etc/elastos/turnserver.conf",
    "/usr/local/etc/elastos/turnserver.conf",
    NULL
};

static const char *tox_bootstrap_config_files[] = {
    "./bootstrapd.conf",
    "/etc/elastos/bootstrapd.conf",
    "/usr/local/etc/elastos/bootstrapd.conf",
    NULL
};

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

static void daemonize(void)
{
    FILE *pid_file;
    char pid_file_path[PATH_MAX];

    sprintf(pid_file_path, "/var/run/%s/%s.pid", PROGRAM_NAME, PROGRAM_NAME);

    // Check if the PID file exists 
    if ((pid_file = fopen(pid_file_path, "r"))) {
        printf("Another instance of the daemon is already running, PID file %s exists.\n", pid_file_path);
        fclose(pid_file);
    }

    // Open the PID file for writing
    pid_file = fopen(pid_file_path, "w+");

    if (pid_file == NULL) {
        printf("Couldn't open the PID file for writing: %s. Exiting.\n", pid_file_path);
        exit(1);
    }

    // Fork off from the parent process
    const pid_t pid = fork();

    if (pid > 0) {
        // parent
        fprintf(pid_file, "%d", pid);
        fclose(pid_file);
        printf("Forked successfully: PID: %d.\n", pid);
        exit(0);
    } else{
        fclose(pid_file);
    } 

    if (pid < 0) {
        printf("Forking failed, exiting.\n");
        exit(-1);
    }

    // Create a new SID for the child process
    if (setsid() < 0) {
        printf("SID creation failure. Exiting.\n");
        exit(-1);
    }
}

int turn_main(int argc, char *argv[]);

static pid_t start_turn_server(const char *turn_server_config)
{
    pid_t pid;

    assert(turn_server_config);

    pid = fork();
    if (pid < 0)
        return -1;

    if (pid == 0) {
        char *args[3];
        int rc;

        //setproctitle("Elastos-Bootstrap-TURN");

        args[0] = (char *)PROGRAM_NAME;
        args[1] = (char *)"-c";
        args[2] = (char *)turn_server_config;

        printf("TURN server: %s %s %s\n", args[0], args[1], args[2]);

        //optreset = 1;  //Not supported on Linux
        opterr = 1;
        optind = 1;
        optopt = '?';
        optarg = NULL;   

        rc = turn_main(3, args);
        exit(rc);
    }

    return pid;
}

int tox_bootstrap_main(int argc, char *argv[]);

static pid_t start_tox_bootstrap(const char *tox_bootstrap_config)
{
    pid_t pid;

    assert(tox_bootstrap_config);

    pid = fork();
    if (pid < 0)
        return -1;

    if (pid == 0) {
        char *args[2];
        char config_arg[PATH_MAX];
        int rc;

        //setproctitle("Elastos-Bootstrap-DHT");

        sprintf(config_arg, "--config=%s", tox_bootstrap_config);
        args[0] = (char *)PROGRAM_NAME;
        args[1] = config_arg;

        printf("Tox bootstrap: %s %s\n", args[0], args[1]);

        //optreset = 1;  //Not supported on Linux
        opterr = 1;
        optind = 1;
        optopt = '?';
        optarg = NULL;   

        rc = tox_bootstrap_main(2, args);
        exit(rc);
    }

    return pid;
}

static int quit = 0;
pid_t turn_server_pid = -1 ;
pid_t tox_bootstrap_pid = -1;

static void terminate(int sig)
{
    char pid_file_path[PATH_MAX];

    sprintf(pid_file_path, "/var/run/%s/%s.pid", PROGRAM_NAME, PROGRAM_NAME);

    quit = 1;

    if (tox_bootstrap_pid > 0) {
        kill(tox_bootstrap_pid, SIGTERM);
        tox_bootstrap_pid = -1;
    }

    if (turn_server_pid > 0) {
        kill(turn_server_pid, SIGTERM);
        turn_server_pid = -1;
    }

    remove(pid_file_path);
}

static void print_help(void)
{
    printf(
        "Usage: elastos-bootstrapd [OPTION]...\n"
        "\n"
        "Options:\n"
        "  --turn-config=FILE           Specify path to the TURN config file.\n"
        "  --bootstrap-config=FILE      Specify path to the bootstrap config file.\n"
        "  --foreground                 Run the daemon in foreground.\n"
        "  --help                       Print this help message.\n"
        "  --version                    Print version information.\n");
}

int main(int argc, char *argv[])
{
    const char *turn_server_config = NULL;
    const char *tox_bootstrap_config = NULL;
    bool run_in_foreground = false;
    time_t startup_time;

    static struct option long_options[] = {
        {"turn-config",             required_argument, 0, 'r'}, 
        {"bootstrap-config",        required_argument, 0, 'b'},
        {"foreground",              no_argument,       0, 'f'},
        {"help",                    no_argument,       0, 'h'},
        {"version",                 no_argument,       0, 'v'},
        {0,                         0,                 0,  0 }
    };

    int opt;

    umask(077);

    printf("Elastos bootstrap daemon, version %s(%lu)\n",
            ELASTOS_BOOTSTRAP_VERSION, ELASTOS_BOOTSTRAP_BUILD_NUMBER);

    while ((opt = getopt_long(argc, argv, "r:b:fhv", long_options, NULL)) != -1) {
        switch (opt) {
            case 'r':
                turn_server_config = strdup(optarg);
                break;

            case 'b':
                tox_bootstrap_config = strdup(optarg);
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

#if 0
    printf("\n========================================================\n");
    printf("Process %d waiting for debugger attach......\n", getpid());
    printf("========================================================\n");
    getchar();
    getchar();
#endif

    turn_server_config = get_config_file(turn_server_config, 
                                    turn_server_config_files);
    if (turn_server_config == NULL) {
        printf("No required TURN server config file specified.\n\n");
        print_help();
        return -1;
    }

    tox_bootstrap_config = get_config_file(tox_bootstrap_config,
                                    tox_bootstrap_config_files);
    if (tox_bootstrap_config == NULL) {
        printf("No required bootstrap config file specified.\n\n");
        print_help();
        return -1;
    }

    printf("TURN config: %s\n", turn_server_config);
    printf("Bootstrap config: %s\n", tox_bootstrap_config);
    
    if (!run_in_foreground)
        daemonize();

    //spt_init(argc, argv);
    //setproctitle("Elastos-Bootstrap-Main");

    startup_time = time(NULL);

    turn_server_pid = start_turn_server(turn_server_config);
    tox_bootstrap_pid = start_tox_bootstrap(tox_bootstrap_config);

    signal(SIGHUP, terminate);
    signal(SIGINT, terminate);
    signal(SIGTERM, terminate);

    while (!quit) {
        int status = 0;

        pid_t pid = waitpid(-1, &status, 0);
        if (pid == turn_server_pid) {
            if ((time(NULL) - startup_time) < 30 || WIFEXITED(status)) {
                turn_server_pid = -1;
                break;
            }

            turn_server_pid = start_turn_server(turn_server_config);
        }

        if (pid == tox_bootstrap_pid) {
            if ((time(NULL) - startup_time) < 30 || WIFEXITED(status)) {
                tox_bootstrap_pid = -1;
                break;
            }

            tox_bootstrap_pid = start_tox_bootstrap(tox_bootstrap_config);
        }
    }

    terminate(0);

    return 0;
}
