project(libevent)

include(CarrierDefaults)
include(ExternalProject)

if( WIN32)
    message(FATAL_ERROR
        "Not support for building libevent for Windows")
else()
    string(APPEND CMAKE_C_FLAGS_INIT
        "-I${CARRIER_INT_DIST_DIR}/include ")

    include(ExternalConfigureArgs)

    set(CONFIGURE_CMD "./configure")
    set(CONFIGURE_ARGS
        "--prefix=${CARRIER_INT_DIST_DIR}"
        "--enable-static"
        "--disable-shared"
        "--enable-openssl"
        "PKG_CONFIG_PATH=${CARRIER_INT_DIST_DIR}/lib/pkgconfig"
        ${CONFIGURE_ARGS_INIT})

    set(BUILD_CMD "make")

    set(INSTALL_CMD "make")
    set(INSTALL_ARGS "install")
endif()

ExternalProject_Add(
    libevent

    PREFIX ${CARRIER_DEPS_BUILD_PREFIX}
    URL "https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz"
    URL_HASH SHA256=965cc5a8bb46ce4199a47e9b2c9e1cae3b137e8356ffdad6d94d3b9069b71dc2
    DOWNLOAD_NAME "libevent-2.1.8-stable.tar.gz"
    DOWNLOAD_DIR ${CARRIER_DEPS_TARBALL_DIR}
    DOWNLOAD_NO_PROGRESS 1

    BUILD_IN_SOURCE 1

    PATCH_COMMAND ${PATCH_EXE} -s -p1 < ${CMAKE_CURRENT_LIST_DIR}/libevent.patch

    CONFIGURE_COMMAND ${CONFIGURE_CMD} ${CONFIGURE_ARGS}
    BUILD_COMMAND ${BUILD_CMD} ${BUILD_ARGS}
    INSTALL_COMMAND ${INSTALL_CMD} ${INSTALL_ARGS}
)
