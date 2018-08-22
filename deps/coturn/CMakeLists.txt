project(coturn)

include(CarrierDefaults)
include(ExternalProject)

if(WIN32)
    message(FATAL_ERROR
        "Not support for building coturn for Windows")
else()
    string(APPEND CMAKE_C_FLAGS_INIT
        "-I${CARRIER_INT_DIST_DIR}/include ")

    include(ExternalConfigureArgs)

    set(CONFIGURE_CMD "./configure")
    set(CONFIGURE_ARGS
        "--prefix=${CARRIER_INT_DIST_DIR}"
        "--bindir=${CARRIER_INT_DIST_DIR}/bin"
        "--confdir=${CARRIER_INT_DIST_DIR}/etc/whisper"
        "--includedir=${CARRIER_INT_DIST_DIR}/include"
        "--libdir=${CARRIER_INT_DIST_DIR}/lib"
        "--schemadir=${CARRIER_INT_DIST_DIR}/usr/share/whisper-turnserver"
        "--examplesdir=${CARRIER_INT_DIST_DIR}/usr/share/examples/whisper-turnserver"
        "--docdir=${CARRIER_INT_DIST_DIR}/usr/share/doc/whisper-turnserver"
        "--manprefix=${CARRIER_INT_DIST_DIR}/usr/share"
        "--localstatedir=${CARRIER_INT_DIST_DIR}/var"
        ${CONFIGURE_ARGS_INIT})

    set(BUILD_CMD "make")

    set(INSTALL_CMD "make")
    set(INSTALL_ARGS "install")

endif()

ExternalProject_Add(
    coturn

    PREFIX ${CARRIER_DEPS_BUILD_PREFIX}
    URL "https://github.com/coturn/coturn/archive/4.5.0.6.tar.gz"
    URL_HASH SHA256=5ad976e142daf392351f86623b217be7ca91322105e0500c379a9dcdbbc466e8
    DOWNLOAD_NAME "coturn-4.5.0.6.tar.gz"
    DOWNLOAD_DIR ${CARRIER_DEPS_TARBALL_DIR}
    DOWNLOAD_NO_PROGRESS 1

    BUILD_IN_SOURCE 1

    PATCH_COMMAND ${PATCH_EXE} -s -p1 < "${CMAKE_CURRENT_LIST_DIR}/coturn.patch"

    CONFIGURE_COMMAND ${CONFIGURE_CMD} ${CONFIGURE_ARGS}
    BUILD_COMMAND ${BUILD_CMD} ${BUILD_ARGS}
    INSTALL_COMMAND ${INSTALL_CMD} ${INSTALL_ARGS}
)
