if(__carrier_packages_included)
    return()
endif()
set(__carrier_packages_included)

## Package Outputs Distribution
set(CPACK_PACKAGE_DESCRIPTION "Elastos Carrier Bootstrap Distribution Packages")
set(CPACK_PACKAGE_VERSION_MAJOR ${CARRIER_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${CARRIER_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${CARRIER_VERSION_PATCH})
set(CPACK_PACKAGE_VENDOR "elastos.org")
set(CPACK_PACKAGE_CONTACT "libin@elastos.org")
if(MACOS)
    set(CPACK_GENERATOR "TGZ")
elseif(LINUX OR RPI)
    set(CPACK_PACKAGING_INSTALL_PREFIX "/")
    set(CPACK_GENERATOR "DEB")
    set(CPACK_DEBIAN_PACKAGE_NAME "elastos-bootstrapd")
    set(CPACK_DEBIAN_PACKAGE_SOURCE "elastos")
    set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "amd64")
    set(CPACK_DEBIAN_PACKAGE_PREDEPENDS "adduser")
    set(CPACK_DEBIAN_PACKAGE_DEPENDS
        "lsb-base (>= 3.0), init-system-helpers (>= 1.18~),
        libc6 (>= 2.14), libsystemd0")
    set(CPACK_DEBIAN_PACKAGE_HOMEPAGE "http://www.elastos.org/")
    set(CPACK_DEBIAN_PACKAGE_DESCRIPTION
        "Elastos Carrier bootstrap (daemon)
        Elastos Carrier is a decentralized peer to peer communication framework.
        .
        This package contains the elastos carrier bootstrap daemon.
        Use this bootstrap built up the well known bootstrap nodes.")
    set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA
        "${CMAKE_SOURCE_DIR}/debian/postinst;
        ${CMAKE_SOURCE_DIR}/debian/postrm;
        ${CMAKE_SOURCE_DIR}/debian/preinst;
        ${CMAKE_SOURCE_DIR}/debian/prerm")
endif()

if(UNIX)
    if(APPLE)
        if(IOS)
            set(PACKAGE_TARGET_SYSTEM "ios")
        else()
            set(PACKAGE_TARGET_SYSTEM "darwin")
        endif()
    else()
        if(ANDROID)
            set(PACKAGE_TARGET_SYSTEM "android")
        elseif(RASPBERRYPI)
            set(PACKAGE_TARGET_SYSTEM "rpi")
        else()
            set(PACKAGE_TARGET_SYSTEM "linux")
        endif()
    endif()

    if(${CMAKE_SYSTEM_PROCESSOR} STREQUAL "aarch64")
        set(PACKAGE_TARGET_ARCH "arm64")
    else()
        set(PACKAGE_TARGET_ARCH ${CMAKE_SYSTEM_PROCESSOR})
    endif()
elseif(WIN32)
    set(PACKAGE_TARGET_SYSTEM "windows")

    if(${CMAKE_SIZEOF_VOID_P} STREQUAL "8")
        set(PACKAGE_TARGET_ARCH "x86_64")
    else()
        set(PACKAGE_TARGET_ARCH "i386")
    endif()
else()
endif()

string(CONCAT CPACK_PACKAGE_FILE_NAME
    "${CMAKE_PROJECT_NAME}-"
    "${CPACK_PACKAGE_VERSION_MAJOR}."
    "${CPACK_PACKAGE_VERSION_MINOR}."
    "${CPACK_PACKAGE_VERSION_PATCH}-"
    "${PACKAGE_TARGET_SYSTEM}-"
    "${PACKAGE_TARGET_ARCH}-"
    "${CMAKE_BUILD_TYPE}")

## Package Source distribution.
set(CPACK_SOURCE_GENERATOR "TGZ")

string(CONCAT CPACK_SOURCE_PACKAGE_FILE_NAME
    "${CMAKE_PROJECT_NAME}-"
    "${CPACK_PACKAGE_VERSION_MAJOR}."
    "${CPACK_PACKAGE_VERSION_MINOR}."
    "${CPACK_PACKAGE_VERSION_PATCH}")

string(CONCAT CPACK_SOURCE_IGNORE_FILES
    "/build;"
    "/.git;"
    "${CPACK_SOURCE_IGNORE_FILES}")

include(CPack)
