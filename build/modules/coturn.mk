include environ/$(HOST)-$(ARCH).mk

PACKAGE_NAME   = coturn-4.5.0.6.tar.gz
PACKAGE_URL    = https://github.com/coturn/coturn/archive/4.5.0.6.tar.gz
SRC_DIR        = $(ROOT_DIR)/src/coturn

CONFIG_COMMAND = $(shell scripts/coturn.sh "command" $(HOST) $(ARCH) $(HOST_COMPILER))
CONFIG_OPTIONS = --prefix=$(DIST_DIR) \
				 --bindir=/bin --confdir=/etc/elastos --includedir=/include --libdir=/lib \
				 --schemadir=/usr/share/elastos-turnserver --examplesdir=/usr/share/examples/elastos-turnserver \
				 --docdir=/usr/share/doc/elastos-turnserver --manprefix=/usr/share --localstatedir=/var/lib/ela-bootstrapd

define source-fetch
    @echo "Using local source in $(SRC_DIR) ..."
endef

define configure
    cd $(SRC_DIR) && TURN_NO_PQ=yes TURN_NO_MYSQL=yes TURN_NO_MONGO=yes TURN_NO_HIREDIS=yes $(CONFIG_COMMAND) $(CONFIG_OPTIONS)
    ./patch/coturn.sh $(SRC_DIR) $(BUILD_DIR) $(HOST)
endef

define install
    cd $(SRC_DIR) && DESTDIR=$(DIST_DIR) make install
endef

define make-clean
    cd $(SRC_DIR) && { \
        if [ -e Makefile ]; then \
            make clean; \
        fi \
    }
endef

define config-clean
    $(call make-clean)
    cd $(SRC_DIR) && { \
        if [ -e Makefile ]; then \
            make distclean; \
        fi \
    }
endef

define source-clean
    $(call config-clean)
    cd $(SRC_DIR) && { \
        for step in source config compile install; do \
            rm -f .$${step}_status; \
        done \
    }
endef

include modules/rules.mk

