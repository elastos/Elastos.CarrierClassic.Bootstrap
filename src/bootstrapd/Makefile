PREFIX ?= /usr/local
INCLUDE_PATH ?= include
LIBRARY_PATH ?= lib

INSTALL_INCLUDE_PATH = $(DESTDIR)$(PREFIX)/$(INCLUDE_PATH)
INSTALL_LIBRARY_PATH = $(DESTDIR)$(PREFIX)/$(LIBRARY_PATH)

INSTALL ?= cp -a

CFLAGS := $(CFLAGS) -I$(INSTALL_INCLUDE_PATH) -fPIC -Wall  -Wstrict-prototypes -Wwrite-strings

LIBS := $(LIBS) -lturnserver -ltox-bootstrapd -ltoxcore -lconfig \
		-levent_openssl -levent_pthreads -levent_extra -levent_core -levent -lsodium \
		-lsqlite3 -lssl -lcrypto -lz -lresolv

ifeq (, $(findstring $(HOST), Darwin iOS))
	LIBS := $(LIBS) -lpthread -ldl
endif

OBJS = bootstrapd.o setproctitle.o

.PHONY: all clean install

all: ela-bootstrapd

ela-bootstrapd: $(OBJS)
	$(CC) -o $@ $(OBJS) $(LDFLAGS) -L$(INSTALL_LIBRARY_PATH) $(LIBS)

.c.o:
	$(CC) -c $(CFLAGS) -o $@ $<

install: all
	cp ela-bootstrapd $(PREFIX)/bin

clean:
	rm -rf ela-bootstrapd *.o
