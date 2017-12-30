include environ/$(HOST)-$(ARCH).mk

PACKAGE_NAME   = zlib-1.2.8.tar.gz
PACKAGE_URL    = https://github.com/madler/zlib/archive/v1.2.8.tar.gz
SRC_DIR        = $(DEPS_DIR)/zlib-1.2.8

CONFIG_COMMAND = $(shell scripts/zlib.sh "command" $(HOST) $(ARCH))
CONFIG_OPTIONS = --prefix=$(DIST_DIR) 

define configure
    cd $(SRC_DIR) && CFLAGS="$(CFLAGS) -fvisibility=hidden -DZEXTERN= -DZEXPORT=" $(CONFIG_COMMAND) $(CONFIG_OPTIONS)
endef

include modules/rules.mk

