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
	cd ${SRC_DIR} \
            && patch -s -p0 Makefile "${BUILD_DIR}/patch/coturn.patch" \
                && sed -ie "s%-lcrypto -lssl -levent_core -levent_extra%-ldl -lssl -lcrypto -levent_extra -levent_core%" Makefile
	;;
    *)
        ;;
esac

exit 0

