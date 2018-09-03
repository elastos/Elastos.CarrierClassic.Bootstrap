cmake_minimum_required(VERSION 2.9)
cmake_policy(VERSION 2.9)
project(elastos-carrier-bootstrap)

if(APPLE AND NOT IOS)
    set(MACOS TRUE)
elseif(UNIX)
    if(RASPBERRYPI)
        set(RPI TRUE)
    elseif(NOT ANDROID)
        set(LINUX TRUE)
    endif()
endif()

if(NOT (MACOS OR RPI OR LINUX))
    message(FATAL_ERROR "Support MacOs, Linux, Raspberry Pi only")
endif()

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
include(CarrierDefaults)
include(CarrierPackages)
include(AddSubModule)

add_subdirectory(deps)
add_subdirectory(src)

# Alias target for package. But it fix issue about making package
# inrelevant to udpatation of cmake scripts.
add_custom_target(dist
    COMMAND ${CMAKE_MAKE_PROGRAM} package
    COMMENT "Package Carrier Bootstrap Distrubtion")
