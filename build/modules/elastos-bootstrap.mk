include environ/$(HOST)-$(ARCH).mk

SRC_DIR  = $(ROOT_DIR)/src/bootstrapd

define source-fetch
    @echo "Using local source in $(SRC_DIR) ..."
endef

define configure
    @echo "Dummy configure ..."
endef

define compile
    cd $(SRC_DIR) && PREFIX=$(DIST_DIR) make
endef

define install
    cd $(SRC_DIR) && PREFIX=$(DIST_DIR) make install
endef

define uninstall
    @echo "Dummy uninstall ..."
endef

define make-clean
    cd $(SRC_DIR) && PREFIX=$(DIST_DIR) make clean
endef

define config-clean
    $(call make-clean)
endef

define source-clean
    $(call make-clean)
endef

define dev-dist
    rm -rf $(DIST_DIR)/debian
    rm -f $(DIST_DIR)/elastos-bootstrapd.deb
    mkdir -p $(DIST_DIR)/debian/usr/bin
    cp $(DIST_DIR)/bin/ela-bootstrapd $(DIST_DIR)/debian/usr/bin
    strip $(DIST_DIR)/debian/usr/bin/ela-bootstrapd
    mkdir -p $(DIST_DIR)/debian/etc/elastos
    cp $(ROOT_DIR)/config/*.conf $(DIST_DIR)/debian/etc/elastos
    mkdir -p $(DIST_DIR)/debian/lib/systemd/system
    cp $(ROOT_DIR)/scripts/ela-bootstrapd.service $(DIST_DIR)/debian/lib/systemd/system
    mkdir -p $(DIST_DIR)/debian/etc/init.d
    cp $(ROOT_DIR)/scripts/ela-bootstrapd.sh $(DIST_DIR)/debian/etc/init.d/ela-bootstrapd
    mkdir -p $(DIST_DIR)/debian/var/lib/ela-bootstrapd
    mkdir -p $(DIST_DIR)/debian/var/run/ela-bootstrapd
    mkdir -p $(DIST_DIR)/debian/var/lib/ela-bootstrapd/db
    mkdir -p $(DIST_DIR)/debian/DEBIAN
    cp $(ROOT_DIR)/debian/* $(DIST_DIR)/debian/DEBIAN
    cd $(DIST_DIR) && dpkg-deb --build debian elastos-bootstrapd.deb
endef

source:
	$(call source-fetch)

config: source
	$(call configure)

make: config
	$(call compile) 

install: make
	mkdir -p $(DIST_DIR)
	$(call install)

dist: install
	$(call dev-dist)

clean:
	$(call make-clean)

config-clean:
	$(call config-clean)

source-clean:
	$(call source-clean)
