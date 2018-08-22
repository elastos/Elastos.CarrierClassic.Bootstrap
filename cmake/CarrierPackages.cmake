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

if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
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

if(APPLE)
    set(PACKAGE_TARGET_SYSTEM "darwin")
    set(PACKAGE_TARGET_ARCH ${CMAKE_SYSTEM_PROCESSOR})
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
    set(PACKAGE_TARGET_SYSTEM "linux")
    set(PACKAGE_TARGET_ARCH ${CMAKE_SYSTEM_PROCESSOR})
else()
    message(FATAL_ERROR, "Unsupported platform to build elastos bootstrapd")
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

