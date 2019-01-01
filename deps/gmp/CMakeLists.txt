project(libgmp)

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
        "PKG_CONFIG_PATH=${CARRIER_INT_DIST_DIR}/lib/pkgconfig"
        ${CONFIGURE_ARGS_INIT})

    set(BUILD_CMD "make")

    set(INSTALL_CMD "make")
    set(INSTALL_ARGS "install")
endif()

ExternalProject_Add(
    libgmp

    PREFIX ${CARRIER_DEPS_BUILD_PREFIX}
    URL "https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz"
    URL_HASH SHA256=87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912
    DOWNLOAD_NAME "gmp-6.1.2.tar.xz"
    DOWNLOAD_DIR ${CARRIER_DEPS_TARBALL_DIR}
    DOWNLOAD_NO_PROGRESS 1

    BUILD_IN_SOURCE 1

    CONFIGURE_COMMAND ${CONFIGURE_CMD} ${CONFIGURE_ARGS}
    BUILD_COMMAND ${BUILD_CMD} ${BUILD_ARGS}
    INSTALL_COMMAND ${INSTALL_CMD} ${INSTALL_ARGS}
)
