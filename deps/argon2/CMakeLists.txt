project(argon2)

include(CarrierDefaults)
include(ExternalProject)
include(ExternalCMakeArgs)

ExternalProject_Add(
    argon2

    PREFIX ${CARRIER_DEPS_BUILD_PREFIX}
    URL "https://codeload.github.com/P-H-C/phc-winner-argon2/tar.gz/20171227"
    URL_HASH SHA256=eaea0172c1f4ee4550d1b6c9ce01aab8d1ab66b4207776aa67991eb5872fdcd8
    DOWNLOAD_NAME "phc-winner-argon2-20171227.tar.gz"
    DOWNLOAD_DIR ${CARRIER_DEPS_TARBALL_DIR}
    DOWNLOAD_NO_PROGRESS 1

    BUILD_IN_SOURCE 1

    PATCH_COMMAND ${PATCH_EXE} -s -p1 < ${CMAKE_CURRENT_LIST_DIR}/argon2.patch

    CONFIGURE_COMMAND echo Done.
    BUILD_COMMAND make PREFIX=${CARRIER_INT_DIST_DIR}
    INSTALL_COMMAND make PREFIX=${CARRIER_INT_DIST_DIR} install
)
