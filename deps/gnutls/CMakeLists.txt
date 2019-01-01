project(gnutls)

include(CarrierDefaults)
include(ExternalProject)
    include(ExternalConfigureArgs)

if( WIN32)
    message(FATAL_ERROR
        "Not support for building GnuTLS for Windows")
else()
    set(CONFIGURE_CMD "./configure")
    set(CONFIGURE_ARGS
        "--prefix=${CARRIER_INT_DIST_DIR}"
        "--with-included-libtasn1"
        "--with-included-unistring"
        "--without-p11-kit"
        "--without-tpm"
        "--disable-libdane"
        "--enable-static"
        "--disable-shared"
        "PKG_CONFIG_PATH=${CARRIER_INT_DIST_DIR}/lib/pkgconfig"
        ${CONFIGURE_ARGS_INIT}
        "LDFLAGS=${CMAKE_C_FLAGS} -L${CARRIER_INT_DIST_DIR}/lib"
        "CFLAGS=${CMAKE_C_FLAGS} -I${CARRIER_INT_DIST_DIR}/include")
# Above two lines(LDFLAGS and CFLAGS) just workaround for configure error.

    set(BUILD_CMD "make")

    set(INSTALL_CMD "make")
    set(INSTALL_ARGS "install")
endif()

ExternalProject_Add(
    gnutls

    PREFIX ${CARRIER_DEPS_BUILD_PREFIX}
    URL "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/gnutls-3.6.5.tar.xz"
    URL_HASH SHA256=073eced3acef49a3883e69ffd5f0f0b5f46e2760ad86eddc6c0866df4e7abb35
    DOWNLOAD_NAME "gnutls-3.6.5.tar.xz"
    DOWNLOAD_DIR ${CARRIER_DEPS_TARBALL_DIR}
    DOWNLOAD_NO_PROGRESS 1

    BUILD_IN_SOURCE 1

    CONFIGURE_COMMAND ${CONFIGURE_CMD} ${CONFIGURE_ARGS}
    BUILD_COMMAND ${BUILD_CMD} ${BUILD_ARGS}
    INSTALL_COMMAND ${INSTALL_CMD} ${INSTALL_ARGS}
)
