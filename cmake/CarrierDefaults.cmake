if(__carrier_defaults_included)
    return()
endif()
set(__carrier_defaults_included TRUE)

# Global default variables defintions
if("${CMAKE_BUILD_TYPE}" STREQUAL "")
    set(CMAKE_BUILD_TYPE "Debug")
endif()

# Carrier Bootstrap Version Defintions.
set(CARRIER_VERSION_MAJOR "5")
set(CARRIER_VERSION_MINOR "1")
execute_process(
    COMMAND git rev-parse master
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_COMMIT_ID
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE)
if("${GIT_COMMIT_ID}" STREQUAL "")
    # Not a git repository, maybe ectracted from downloaded tarball.
    set(CARRIER_VERSION_PATCH "unknown")
else()
    string(SUBSTRING ${GIT_COMMIT_ID} 0 6 CARRIER_VERSION_PATCH)
endif()

# Elastos bootstrapd Version Defintions.
set(ELASTOS_BOOTSTRAPD_VERSION_MAJOR ${CARRIER_VERSION_MAJOR})
set(ELASTOS_BOOTSTRAPD_VERSION_MINOR ${CARRIER_VERSION_MINOR})

execute_process(COMMAND date "+%Y%m%d"
        OUTPUT_VARIABLE _BUILD_NUMBER
        ERROR_QUIET
        OUTPUT_STRIP_TRAILING_WHITESPACE)
set(ELASTOS_BOOSTRAPD_BUILD_NUMBER ${_BUILD_NUMBER})

# Third-party dependency tarballs directory
set(CARRIER_DEPS_TARBALL_DIR "${CMAKE_SOURCE_DIR}/build/.tarballs")
set(CARRIER_DEPS_BUILD_PREFIX "external")

# Intermediate distribution directory
set(CARRIER_INT_DIST_DIR "${CMAKE_BINARY_DIR}/intermediates")
if(WIN32)
    file(TO_NATIVE_PATH
        "${CARRIER_INT_DIST_DIR}" CARRIER_INT_DIST_DIR)
endif()

# Host tools directory
set(CARRIER_HOST_TOOLS_DIR "${CMAKE_BINARY_DIR}/host")
if(WIN32)
    file(TO_NATIVE_PATH
         "${CARRIER_HOST_TOOLS_DIR}" CARRIER_HOST_TOOLS_DIR)
endif()

set(PATCH_EXE "patch")

set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
set(CMAKE_MACOSX_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
