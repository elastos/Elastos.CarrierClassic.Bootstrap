include environ/$(HOST)-$(ARCH).mk

PACKAGE_NAME   = sqlite-3.21.0.tar.gz
PACKAGE_URL    = http://sqlite.org/2017/sqlite-autoconf-3210000.tar.gz
SRC_DIR        = $(DEPS_DIR)/sqlite-autoconf-3210000

CONFIG_COMMAND = $(shell scripts/sqlite.sh "command" $(HOST) $(ARCH) $(HOST_COMPILER))
CONFIG_OPTIONS = --prefix=$(DIST_DIR) \
        --enable-shared=no \
        --disable-shared \
        --enable-static \
        --with-pic=yes

define configure
    cd $(SRC_DIR) && CFLAGS="$(CFLAGS) -fvisibility=hidden" $(CONFIG_COMMAND) $(CONFIG_OPTIONS)
endef

define compile
    cd $(SRC_DIR) && CFLAGS="$(CFLAGS) -fvisibility=hidden" make
endef

include modules/rules.mk

