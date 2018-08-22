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
