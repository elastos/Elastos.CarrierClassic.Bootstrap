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
    case $(HOST) in \
        "Linux") \
            ;; \
        "Darwin") \
            echo "Error: Unsupported distribution package on $(HOST)"; \
            echo "Hint: Make debian dist package only allowed on Linux"; \
            exit 1; \
            ;; \
    esac

    ### clean generated environment.
    cd $(DIST_DIR) && { \
        rm -rf debian; \
        rm -rf elastos-bootstrapd.deb; \
    }

    cd $(DIST_DIR) && { \
        mkdir -p debian/usr/bin; \
        cp bin/ela-bootstrapd debian/usr/bin; \
        strip debian/usr/bin/ela-bootstrapd; \
        mkdir -p debian/etc/elastos; \
        cp $(ROOT_DIR)/config/bootstrapd.conf debian/etc/elastos; \
        mkdir -p debian/lib/systemd/system; \
        cp $(ROOT_DIR)/scripts/ela-bootstrapd.service debian/lib/systemd/system; \
        mkdir -p debian/etc/init.d; \
        cp $(ROOT_DIR)/scripts/ela-bootstrapd.sh debian/etc/init.d/ela-bootstrapd; \
        mkdir -p debian/var/lib/ela-bootstrapd; \
        mkdir -p debian/var/lib/ela-bootstrapd/db; \
        mkdir -p debian/DEBIAN; \
        cp $(ROOT_DIR)/debian/* debian/DEBIAN; \
        dpkg-deb --build debian elastos-bootstrapd.deb; \
    }
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
