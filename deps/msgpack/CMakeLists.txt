project(msgpack-c)

include(CarrierDefaults)
include(ExternalProject)
include(ExternalCMakeArgs)

ExternalProject_Add(
    msgpack-c

    PREFIX ${CARRIER_DEPS_BUILD_PREFIX}
    URL "https://codeload.github.com/msgpack/msgpack-c/tar.gz/cpp-3.1.1"
    URL_HASH SHA256=bda49f996a73d2c6080ff0523e7b535917cd28c8a79c3a5da54fc29332d61d1e
    DOWNLOAD_NAME "msgpack-c-cpp-3.1.1.tar.gz"
    DOWNLOAD_DIR ${CARRIER_DEPS_TARBALL_DIR}
    DOWNLOAD_NO_PROGRESS 1

    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CARRIER_INT_DIST_DIR}
        -DMSGPACK_ENABLE_SHARED=OFF
        -DMSGPACK_ENABLE_STATIC=ON
        ${CMAKE_ARGS_INIT}
)
