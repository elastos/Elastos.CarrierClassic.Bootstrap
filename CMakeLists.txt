cmake_minimum_required(VERSION 2.9)
cmake_policy(VERSION 2.9)
project(elastos-carrier-bootstrap)

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
include(CarrierDefaults)
include(CarrierPackages)
include(AddSubModule)

add_subdirectory(deps)
add_subdirectory(src)

# Alias target for package. But it fix issue about making package
# inrelevant to udpatation of cmake scripts.
if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
    add_custom_target(dist
        COMMAND ${CMAKE_MAKE_PROGRAM} package
        COMMENT "Package Carrier Bootstrap Distrubtion")
endif()

