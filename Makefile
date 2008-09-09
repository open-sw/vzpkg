BINDIR  = /usr/bin
SBINDIR = /usr/sbin
LIBDIR  = /usr/share/vzpkg2
MANDIR  = /usr/share/man
MAN8DIR = $(MANDIR)/man8

BIN_FILES    = vzpkgcache vzpkgadd vzpkgrm vzpkgupd vzpkgquery vzpkgls vzosname
LIB_FILES    = functions cache-os \
	apt-cache-install apt-cache-update apt-checkupdate apt-functions \
	apt-add apt-query apt-rm apt-update \
	yum-cache-install yum-cache-update yum-checkupdate yum-functions \
	yum-add yum-query yum-rm yum-update
MAN8_FILES   = man/vzpkgcache.8
MYINIT_FILES = myinit.i386 myinit.x86_64 myinit.ia64

all:

clean:

install: install-bin install-lib install-myinit install-man

install-bin: $(BIN_FILES)
	mkdir -p $(DESTDIR)$(BINDIR)
	for f in $(BIN_FILES); do \
		install -m 755 $$f $(DESTDIR)$(BINDIR); \
	done

install-lib: $(LIB_FILES)
	mkdir -p $(DESTDIR)$(LIBDIR)
	for f in $(LIB_FILES); do \
		install -m 755 $$f $(DESTDIR)$(LIBDIR); \
	done

install-myinit: install-lib
	for f in $(MYINIT_FILES); do \
		install -m 755 $$f $(DESTDIR)$(LIBDIR); \
	done

install-man: install-man8
	mkdir -p $(DESTDIR)$(MANDIR)

install-man8: $(MAN8_FILES)
	mkdir -p $(DESTDIR)$(MAN8DIR)
	for f in $(MAN8_FILES); do \
		install -m 644 $$f $(DESTDIR)$(MAN8DIR); \
	done

tar:
	(VERSION=`awk '/Version:/{print $$2}' < vzpkg.spec` && \
	rm -f ../vzpkg2-$$VERSION; ln -sf `pwd` ../vzpkg2-$$VERSION && \
	tar --directory ..  --exclude CVS --exclude .git --exclude \*.tar.bz2 -cvhjf ../vzpkg2-$$VERSION.tar.bz2 vzpkg2-$$VERSION; \
	tar --directory ..  --exclude CVS --exclude .git --exclude \*.tar.bz2 -cvhzf ../vzpkg2-$$VERSION.tar.gz vzpkg2-$$VERSION; \
	rm -f ../vzpkg2-$$VERSION)

.PHONY: all install install-bin install-lib install-myinit install-man install-man8 tar
