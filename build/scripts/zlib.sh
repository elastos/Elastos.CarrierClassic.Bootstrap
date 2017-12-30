#!/bin/sh

getConfigureCmd() {
    case "$1,$2" in
        *,"x86_64")
            _TOOL="./configure --static --64"
            ;;
        *,"arm64" | *,"arm" | *,"x86" | *,"mips" | *,"armv7l")
            _TOOL="./configure --static"
            ;;
        *,*)
            echo "Not supported platform:Arch ($1:$2)"
            exit 1;;
    esac

    echo ${_TOOL}
}

if [ x"$1" = x"command" ]; then
    getConfigureCmd $2 $3
    exit 0
fi

exit 0

