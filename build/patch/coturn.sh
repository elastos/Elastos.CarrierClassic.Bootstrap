#!/bin/sh

#argv1: SRC_DIR
#argv2: BUILD_DIR
#artv2: HOST

SRC_DIR=$1
shift
BUILD_DIR=$1
shift
HOST=$1

case ${HOST} in
    "Linux")
	cd ${SRC_DIR} && patch -s -p0 Makefile "${BUILD_DIR}/patch/coturn.patch"
	;;
    *)
        ;;
esac

exit 0

