include environ/$(HOST)-$(ARCH).mk

PACKAGE_NAME   = openssl-1.0.2h.tar.gz
PACKAGE_URL    = https://www.openssl.org/source/$(PACKAGE_NAME)
SRC_DIR        = $(DEPS_DIR)/openssl-1.0.2h

CONFIG_COMMAND = $(shell ./scripts/openssl.sh "command"  $(HOST) $(ARCH))
CONFIG_OPTIONS = no-asm \
        no-dso \
        no-shared \
        no-zlib \
        --prefix=$(DIST_DIR)

define configure
    cd $(SRC_DIR) && $(CONFIG_COMMAND) $(CONFIG_OPTIONS) 
    sed -ie "s%^CFLAG= -%CFLAG= ${CFLAGS} -fvisibility=hidden -%" "${SRC_DIR}/Makefile"
    sed -ie "s%makedepend%${CC} -M%" "${SRC_DIR}/Makefile"
    cd $(SRC_DIR) && make depend
endef

define install 
    cd $(SRC_DIR) && make install_sw
endef

define uninstall 
    for m in "ssl" "crypto"; do \
        rm -f $(DIST_DIR)/lib/lib$$m.a; \
    done; \
    for d in "ssl" "bin/openssl" "include/openssl"; do \
        rm -rf $(DIST_DIR)/$$d; \
    done
endef

include modules/rules.mk

