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
    cd $(SRC_DIR) && { \
        if [ -e Makefile ]; then \
            make clean && make distclean; \
        fi; \
        rm -rf autom4te.cache; \
        rm -rf configure configure_aux; \
        rm -f Makefile Makefile.in; \
        rm -f config.h config.h.in; \
        rm -f libtool; \
        rm -f build/Makefile build/Makefile.in; \
        for step in source config compile install; do \
            rm -f .$${step}_status; \
        done \
    }
endef

define config-clean
    cd $(SRC_DIR) && { \
        if [ -e Makefile ]; then \
            make clean && make distclean; \
        fi \
    }
endef

include modules/rules.mk


