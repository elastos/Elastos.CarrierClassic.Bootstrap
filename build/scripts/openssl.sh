#!/bin/sh

getConfigureCmd() {
    case $1,$2 in
        "Linux","x86_64"| "Raspbian","armv7l")
            _TOOL="./config"
            ;;
        "Linux","armv7l")
            _TOOL="./Configure dist"
            ;;
        "Darwin","x86_64")
            _TOOL="./Configure darwin64-x86_64-cc"
            ;;
        "Darwin","x86")
            _TOOL="./Configure darwin-i386-cc"
            ;;
        *,*)
            echo "Unsupported Host: Arch($1:$2) for openssl configure"
            exit 1
    esac

    echo ${_TOOL}
}

if [ x"$1" = x"command" ]; then
    getConfigureCmd $2 $3
    exit 0
fi

exit 0

