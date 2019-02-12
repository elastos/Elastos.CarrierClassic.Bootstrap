project(opendht)

include(CarrierDefaults)
include(ExternalProject)
include(ExternalCMakeArgs)

ExternalProject_Add(
    opendht

    PREFIX ${CARRIER_DEPS_BUILD_PREFIX}
    URL "https://codeload.github.com/savoirfairelinux/opendht/tar.gz/1.8.1"
    URL_HASH SHA256=96564cd3c7fee711e7bcd71a83fef0e02721b06c1de921abf73b1872e616f962
    DOWNLOAD_NAME "opendht-1.8.1.tar.gz"
    DOWNLOAD_DIR ${CARRIER_DEPS_TARBALL_DIR}
    DOWNLOAD_NO_PROGRESS 1

    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CARRIER_INT_DIST_DIR}
        -DOPENDHT_STATIC=ON
        -DOPENDHT_SHARED=OFF
        -DOPENDHT_LOG=OFF
        -DOPENDHT_PYTHON=OFF
        -DOPENDHT_LTO=ON
        -DOPENDHT_TOOLS=OFF
        -DOPENDHT_SYSTEMD=OFF
        -DOPENDHT_ARGON2=OFF
        -DCMAKE_PREFIX_PATH=${CARRIER_INT_DIST_DIR}
        -DPKG_CONFIG_USE_CMAKE_PREFIX_PATH=ON
        ${CMAKE_ARGS_INIT}
)
