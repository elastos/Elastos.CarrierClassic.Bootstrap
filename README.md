# Elastos Carrier Bootstrap Daemon 

[![Build Status](https://travis-ci.com/elastos/Elastos.NET.Carrier.Bootstrap.svg?branch=master)](https://travis-ci.com/elastos/Elastos.NET.Carrier.Bootstrap)

## Summary

Elastos Carrier bootstrap daemon is an essential service to help new nodes join and bootstrap the Elastos Carrier network.

## Build from source

### GNU/Linux (Ubuntu 16.04-x86_64 LTS is recommended)

Currently, **GNU/Linux is the only recommend platform** to run the Elastos carrier bootstrapd officially.

#### 1. Install Pre-requirements

Run the following commands to install all pre-requirements.

```shell
$ sudo apt-get update
$ sudo apt-get install build-essential autoconf automake autopoint libtool bison texinfo pkg-config cmake
```

#### 2. Build

Change to the directory `$(SRC_DIR)/build`, and run the following commands:

```shell
$ mkdir linux
$ cd linux
$ cmake -DCMAKE_INSTALL_PREFIX=outputs ../..
$ make install
```

To build Debian (.deb) package, run command with `"dist"` option:

```shell
$ make dist
```

The generated Debian package will be located at the current working directory. You can use the command to locate it:

```shell
$ ls -la *.deb
```

#### 3. Deployment & Run

Recommended target platform: **Ubuntu server 16.04 LTS / x86_64**

Copy generated Debian package (.deb file) to target machine. Then run following command to install Elastos Carrier bootstrap daemon:

```shell
$ sudo dpkg -i /path/to/elastos_bootstrapd.deb
```

After the install complete, the bootstrap daemon will start automatically. You can run:

```shell
$ sudo systemctl status ela-bootstrapd
```

to check the service status. If the daemon started successfully, the status should be **active (running)**.

Reference: [Man page for systemctl](https://www.freedesktop.org/software/systemd/man/systemctl.html).

***NOTICE:***

##### 1. Update bootstrap nodes list
After installed Elastos Carrier bootstrap daemon, you should modify `/etc/elastos/bootstrapd.conf`, update the **bootstrap_nodes** section according your deployment.

##### 2. Set external IP to turn server explicitly
Some Linux VPS servers , for example, servers from AWS, can't fetch public IP address directly by itself,  so you have manually update the public IP address of item **external_ip** in section **turn** for config file `/etc/elastos/bootstrap.conf`.

### MacOS

You can also develop Elastos Carrier bootstrapd on MacOS for testing or debugging purposes.

#### 1. Install Pre-requirents

You need to install the following utility packages on your MacOS before build.

```
autoconf automake cmake libtool shtool pkg-config gettext
```

Or, you can use `brew` command to install the packages:

```
brew install autoconf automake cmake libtool shtool pkg-config gettext
```

#### 2. Build

Change to directory `$(SRC_DIR)/build`, and run the following commands:

```shell
$ mkdir macos
$ cd macos
$ cmake -DCMAKE_INSTALL_PREFIX=outputs ../..
$ make install
```

After that, you can run the following commands to run **ela-bootstrapd** to boost the bootstrap node as long as finishing certian configurations:

```shell
$ cd outputs/usr/bin
$ ./ela-bootstrapd --config=../../etc/elastos/bootstrapd.conf --foreground
```

#### 3. Deployment

Elastos Carrier bootstrap daemon currently does not support MacOS.

## Thanks

Sincerely thanks to all teams and projects that we rely on directly or indirectly.

## License

GPLv3

