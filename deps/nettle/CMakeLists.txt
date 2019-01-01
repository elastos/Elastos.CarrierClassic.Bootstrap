project(libnettle)

include(CarrierDefaults)
include(ExternalProject)
include(ExternalConfigureArgs)

if( WIN32)
    message(FATAL_ERROR
        "Not support for building Nettle for Windows")
else()
    set(CONFIGURE_CMD "./configure")
    set(CONFIGURE_ARGS
        "--prefix=${CARRIER_INT_DIST_DIR}"
        "--enable-static"
        "--disable-shared"
        "--disable-openssl"
        "--enable-public-key"
        "--with-include-path=${CARRIER_INT_DIST_DIR}/include"
        "--with-lib-path=${CARRIER_INT_DIST_DIR}/lib"
        "PKG_CONFIG_PATH=${CARRIER_INT_DIST_DIR}/lib/pkgconfig"
        ${CONFIGURE_ARGS_INIT})

    set(BUILD_CMD "make")

    set(INSTALL_CMD "make")
    set(INSTALL_ARGS "install")
endif()

ExternalProject_Add(
    libnettle

    PREFIX ${CARRIER_DEPS_BUILD_PREFIX}
    URL "https://ftp.gnu.org/gnu/nettle/nettle-3.4.1.tar.gz"
    URL_HASH SHA256=f941cf1535cd5d1819be5ccae5babef01f6db611f9b5a777bae9c7604b8a92ad
    DOWNLOAD_NAME "nettle-3.4.1.tar.gz"
    DOWNLOAD_DIR ${CARRIER_DEPS_TARBALL_DIR}
    DOWNLOAD_NO_PROGRESS 1

    BUILD_IN_SOURCE 1

    CONFIGURE_COMMAND ${CONFIGURE_CMD} ${CONFIGURE_ARGS}
    BUILD_COMMAND ${BUILD_CMD} ${BUILD_ARGS}
    INSTALL_COMMAND ${INSTALL_CMD} ${INSTALL_ARGS}
)
