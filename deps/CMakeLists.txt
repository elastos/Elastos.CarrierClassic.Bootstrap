include(AddSubModule)

add_submodule(libsodium)
add_submodule(libconfig)
add_submodule(zlib)
add_submodule(libressl)
add_submodule(sqlite)
add_submodule(libevent
    DEPENDS zlib libressl)
add_submodule(toxcore0
    DIRECTORY toxcore
    DEPENDS libsodium libconfig)
add_submodule(coturn
    DEPENDS libevent libressl sqlite libsodium toxcore0)
add_submodule(libgmp
    DIRECTORY gmp)
add_submodule(libnettle
    DIRECTORY nettle
    DEPENDS libgmp)
add_submodule(gnutls
    DEPENDS libnettle)
add_submodule(msgpack-c
    DIRECTORY msgpack)
add_submodule(argon2)
add_submodule(opendht
    DEPENDS gnutls msgpack-c argon2)
