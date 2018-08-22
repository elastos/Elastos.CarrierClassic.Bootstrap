project(carrier-bootstrap)

include(CarrierDefaults)
include(CheckIncludeFile)

check_include_file(unistd.h HAVE_UNISTD_H)
if(HAVE_UNISTD_H)
    add_definitions(-DHAVE_UNISTD_H=1)
endif()

configure_file(
    bootstrapd/version.h.in
    version.h
    "@ONLY")

set(SRC
    bootstrapd/bootstrapd.c
    bootstrapd/setproctitle.c)

if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
    set(SYSTEM_LIBS pthread m dl)
elseif(APPLE)
    set(SYSTEM_LIBS pthread dl)
endif()

include_directories(
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CARRIER_INT_DIST_DIR}/include
    bootstrapd)

link_directories(${CARRIER_INT_DIST_DIR}/lib)

add_executable(ela-bootstrapd ${SRC})
add_dependencies(ela-bootstrapd
    toxcore0
    coturn
    libconfig
    libevent
    libsodium
    sqlite
    libressl
    zlib)

target_link_libraries(ela-bootstrapd
    turnserver
    tox-bootstrapd
    toxcore
    toxdht
    toxcrypto
    toxnetwork
    toxnetcrypto
    config
    event_openssl
    event_pthreads
    event_extra
    event_core
    event sodium
    sqlite3
    ssl
    crypto
    z
    resolv
    ${SYSTEM_LIBS})

install(TARGETS ela-bootstrapd
    RUNTIME DESTINATION "bin"
    ARCHIVE DESTINATION "lib"
    LIBRARY DESTINATION "lib")
install(FILES ${CMAKE_SOURCE_DIR}/config/bootstrapd.conf
    DESTINATION "etc/elastos")
install(FILES ${CMAKE_SOURCE_DIR}/scripts/ela-bootstrapd.service
    DESTINATION "lib/systemd/system")
install(PROGRAMS ${CMAKE_SOURCE_DIR}/scripts/ela-bootstrapd.sh
    DESTINATION "etc/init.d/ela-bootstrapd")
install(DIRECTORY
    DESTINATION "var/lib/ela-bootstrapd/db")
install(DIRECTORY ${CMAKE_SOURCE_DIR}/debian
    DESTINATION "DEBIAN"
    USE_SOURCE_PERMISSIONS)
