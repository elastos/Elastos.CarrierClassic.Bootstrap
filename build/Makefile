NEED_DEPS = $(if $(TARGET), \
                 $(filter $(filter $(TARGET), make install dist source-clean), $(TARGET)), \
                 "install" \
             )

.PHONY: all elastos-bootstrap
all: elastos-bootstrap

$(MODULE):
	make -f modules/$(MODULE).mk $(TARGET)

%:
	make -f modules/$@.mk $(TARGET)

ifneq (, $(strip $(NEED_DEPS)))

elastos-bootstrap: toxcore coturn

toxcore: libsodium libconfig
coturn: libevent openssl sqlite
libevent: zlib openssl

endif

help:
	@echo "Usage: MODULE=[module] TARGET=[target] HOST=[platform] ARCH=[machine] BUILD=[build] make [module]"
	@echo "module options:"
	@echo "    libsodium"
	@echo "    libconfig"
	@echo "    zlib"
	@echo "    openssl"
	@echo "    libevent"
	@echo "    sqlite"
	@echo "    toxcore"
	@echo "    coturn"
	@echo "    elastos-bootstrap"
	@echo ""
	@echo "platform options:"
	@echo "    Linux(default)"
	@echo "    Darwin"
	@echo ""
	@echo "machine options:"
	@echo "    x86_64(default)"
	@echo ""
	@echo "build options:"
	@echo "    debug(default)"
	@echo "    release"
	@echo ""
	@echo "target options:"
	@echo "    source"
	@echo "    config"
	@echo "    make"
	@echo "    install"
	@echo "    dist"
	@echo "    source-clean"
	@echo "    config-clean"
	@echo "    clean"
	@echo "    uninstall"
	@echo ""
	@echo "Help option:"
	@echo "    help"
	@echo ""
