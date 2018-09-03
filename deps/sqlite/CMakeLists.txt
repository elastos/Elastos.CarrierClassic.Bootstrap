project(sqlite)

include(CarrierDefaults)
include(ExternalProject)

if(WIN32)
    set_win_build_options(WIN_BUILD_OPTIONS "Static")

    set(CONFIGURE_CMD "echo")
    set(CONFIGURE_ARGS "Done")

    set(BUILD_CMD "msbuild")
    set(BUILD_ARGS ${WIN_BUILD_OPTIONS}
        "sqlite_vs2017.sln")

    set(INSTALL_CMD "echo")
    set(INSTALL_ARGS "Done")
else()
    include(ExternalConfigureArgs)

    set(CONFIGURE_CMD "./configure")
    set(CONFIGURE_ARGS
        "--prefix=${CARRIER_INT_DIST_DIR}"
        "--enable-shared=no"
        "--disable-shared"
        "--enable-static=yes"
        "--with-pic=yes"
        ${CONFIGURE_ARGS_INIT})

    set(BUILD_CMD "make")

    set(INSTALL_CMD "make")
    set(INSTALL_ARGS "install")
endif()

ExternalProject_Add(
    sqlite

    PREFIX ${CARRIER_DEPS_BUILD_PREFIX}
    URL "http://sqlite.org/2017/sqlite-autoconf-3210000.tar.gz"
    URL_HASH SHA256=d7dd516775005ad87a57f428b6f86afd206cb341722927f104d3f0cf65fbbbe3
    DOWNLOAD_NAME "sqlite-3.21.0.tar.gz"
    DOWNLOAD_DIR ${CARRIER_DEPS_TARBALL_DIR}
    DOWNLOAD_NO_PROGRESS 1

    BUILD_IN_SOURCE 1

    CONFIGURE_COMMAND ${CONFIGURE_CMD} ${CONFIGURE_ARGS}
    BUILD_COMMAND ${BUILD_CMD} ${BUILD_ARGS}
    INSTALL_COMMAND ${INSTALL_CMD} ${INSTALL_ARGS}
)
