project(toxcore)

include(CarrierDefaults)
include(ExternalProject)
include(ExternalCMakeArgs)

if(NOT WIN32 AND NOT CMAKE_CROSSCOMPILING)
    set(TOX_BOOTSTRAP_OPT -DBOOTSTRAP_DAEMON=ON)
endif()

ExternalProject_Add(
    toxcore0

    PREFIX ${CARRIER_DEPS_BUILD_PREFIX}
    URL "https://github.com/elastos/c-toxcore/archive/v0.2.12.carrier.tar.gz"
    URL_HASH SHA256=9a6276d8c4e5202b972d45819fd0b47ff9b55750c8f35a83d54f3ca4a4726381
    DOWNLOAD_NAME "c-toxcore-0.2.12.carrier.tar.gz"
    DOWNLOAD_DIR ${CARRIER_DEPS_TARBALL_DIR}
    DOWNLOAD_NO_PROGRESS 1

    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CARRIER_INT_DIST_DIR}
        -DENABLE_SHARED=OFF
        -DENABLE_STATIC=ON
        -DBUILD_TOXAV=OFF
        -DDHT_BOOTSTRAP=ON
        -DBUILD_CARRIER=ON
        ${TOX_BOOTSTRAP_OPT}
        ${CMAKE_ARGS_INIT}
)
