# Elastos Carrier Boostrap Daemon

## Summary

Elastos Carrier boostrap daemon is a basic service to help new node join and bootstrap the Elastos Carrier network.

## Build from source

### Ubuntu

Currently, **Linux is the only recommend platform** to run the Elastos carrier boostrapd officially.

#### 1. Install Pre-requirements

Run the following commands to install all pre-requirements.

```
$ sudo apt-get update
$ sudo apt-get install build-essential autoconf automake autopoint libtool bison
```

#### 2. Build

Change to the directory `$(SRC_DIR)/build`, and run the following command:

```
$ ./linux_build.sh
```

To build Debian (.deb) package, run command with `"dist"` option:

```bash
$ ./linux_build.sh dist
```

The generated Debian package' location is: `$(SRC_DIR)/build/_dist/Linux-x86_64/[debug|release]/elastos_bootstrapd.deb`

For more build options, run command with `"help"` option:

```
$ ./linux_build.sh help
```

#### 3. Deployment & Run

Recommended target platform: **Ubuntu server 16.04 LTS / x86_64**

Copy generated Debian package (.deb file) to target machine. Then run following command to install Elastos Carrier bootstrap daemon:

```shell
$ sudo dpkg -i /path/to/elastos_bootstrapd.deb
```

After install complete, the bootstrap deamon will start automatically. You can run:

```shell
$ sudo systemctl status ela-bootstrapd
```

to check the service status. If the deamon started successful, the status should be **active (running)**.

Reference: [Man page for systemctl](https://www.freedesktop.org/software/systemd/man/systemctl.html).

***NOTICE:*** 

After installed Elastos Carrier bootstrap deamon, you should modify `/etc/elastos/bootstrapd.conf`, update the **bootstrap_nodes** section according your deployment.

### MacOS

For convenience, you can develop Elastos Carrier boostrapd on MacOS for testing or debugging.

#### 1. Install Pre-requirents

You need to install the following utility packages on your MacOS before build.

```
autoconf automake libtool shtool pkg-config gettext
```

Or, you can use `brew` command to install the packages:

```
brew install autoconf automake libtool shtool pkg-config gettext
```

#### 2. Build

Change to directory `$(SRC_DIR)/build`, and run the following command:

```
$ ./darwin_build.sh
```

For more build options, run build script with "help" option:

```
$ ./darwin_build.sh help
```

#### 3. Deployment

Elastos Carrier bootstrap daemon currently not support deploy on MacOS.
