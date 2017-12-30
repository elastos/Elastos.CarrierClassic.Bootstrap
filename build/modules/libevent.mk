include environ/$(HOST)-$(ARCH).mk

PACKAGE_NAME   = libevent-2.1.8-stable.tar.gz
PACKAGE_URL    = https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
SRC_DIR        = $(DEPS_DIR)/libevent-2.1.8-stable

CONFIG_COMMAND = $(shell scripts/libevent.sh "command" $(HOST) $(ARCH) $(HOST_COMPILER))
CONFIG_OPTIONS = --prefix=$(DIST_DIR) \
        --enable-static \
        --disable-shared \
        --enable-openssl

define configure
    if [ ! -e $(SRC_DIR)/configure ]; then \
        cd $(SRC_DIR) && ./autogen.sh; \
    fi

    cd $(SRC_DIR) && CFLAGS="$(CFLAGS) -I$(DIST_DIR)/include" LDFLAGS="-L$(DIST_DIR)/lib" $(CONFIG_COMMAND) $(CONFIG_OPTIONS)
endef

define make-clean
    cd $(SRC_DIR) && make clean
endef

define config-clean
    for c in "clean" "distclean"; do \
        cd $(SRC_DIR) && make $$c-all; \
    done;
endef

include modules/rules.mk


