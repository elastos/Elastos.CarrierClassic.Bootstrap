include environ/$(HOST)-$(ARCH).mk

PACKAGE_NAME   = c-toxcore-0.1.10.tar.gz
PACKAGE_URL    = https://github.com/TokTok/c-toxcore/releases/download/v0.1.10/$(PACKAGE_NAME)
SRC_DIR        = $(ROOT_DIR)/src/c-toxcore

CONFIG_COMMAND = $(shell scripts/toxcore.sh "command" $(HOST) $(ARCH) $(HOST_COMPILER))
CONFIG_OPTIONS = --prefix=$(DIST_DIR) \
        --with-dependency-search=$(DIST_DIR) \
        --enable-static \
        --disable-shared \
        --enable-logging \
        --enable-ntox \
        --enable-daemon \
        --enable-dht-bootstrap \
        --enable-tests \
        --enable-testing \
        --disable-av

define source-fetch
    @echo "Using local source in $(SRC_DIR) ..."
endef

define configure
    if [ ! -e $(SRC_DIR)/configure ]; then \
        cd $(SRC_DIR) && libtoolize -fi && autoreconf -fi; \
    fi
    cd $(SRC_DIR) && CFLAGS="$(CFLAGS) -fvisibility=hidden" $(CONFIG_COMMAND) $(CONFIG_OPTIONS)
endef

define source-clean
    cd $(SRC_DIR) && make clean
    rm $(SRC_DIR)/configure
    rm -rf $(SRC_DIR)/configure_aux
    rm $(SRC_DIR)/Makefile.in
    rm $(SRC_DIR)/Makefile
    rm $(SRC_DIR)/config.h
    rm $(SRC_DIR)/config.h.in
    rm $(SRC_DIR)/libtool
    rm $(SRC_DIR)/build/Makefile.in
    rm $(SRC_DIR)/build/Makefile
    rm -rf $(SRC_DIR)/autom4te.cache
    rm $(SRC_DIR)/.source_status $(SRC_DIR)/.config_status $(SRC_DIR)/.compile_status $(SRC_DIR)/.install_status
endef

include modules/rules.mk


