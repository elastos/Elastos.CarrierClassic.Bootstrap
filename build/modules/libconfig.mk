include environ/$(HOST)-$(ARCH).mk

PACKAGE_NAME   = libconfig-1.7.1.tar.gz
PACKAGE_URL    = https://github.com/hyperrealm/libconfig/archive/v1.7.1.tar.gz
SRC_DIR        = $(DEPS_DIR)/libconfig-1.7.1

CONFIG_COMMAND = $(shell scripts/libconfig.sh "command" $(HOST) $(ARCH) $(HOST_COMPILER))
CONFIG_OPTIONS = --prefix=$(DIST_DIR) \
        --enable-shared=no \
        --disable-shared \
        --enable-static \
        --with-pic=yes \
        --disable-cxx

define configure
    cd $(SRC_DIR) && aclocal --force
    cd $(SRC_DIR) && autoheader --force
    cd $(SRC_DIR) && automake --add-missing
    cd $(SRC_DIR) && autoconf --force 
    cd $(SRC_DIR) && CFLAGS="$(CFLAGS) -fvisibility=hidden -DSODIUM_STATIC" $(CONFIG_COMMAND) $(CONFIG_OPTIONS)
endef

define compile
    cd $(SRC_DIR) && CFLAGS="$(CFLAGS) -fvisibility=hidden -DSODIUM_STATIC" make
endef

include modules/rules.mk

