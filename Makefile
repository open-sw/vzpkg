NAME=vzpkg
# Do not use rpmquery here since some people may not have rpm installed.
# Still, we want to use spec file as a primary source for version info.
VERSION=$(shell awk '/^Version:/ {print $$2}' vzpkg.spec)

DISTFILE=$(NAME)-$(VERSION).tar.bz2

DESTDIR=
BINDIR=$(DESTDIR)/usr/bin
SBINDIR=$(DESTDIR)/usr/sbin
LIBDIR=$(DESTDIR)/usr/share/vzpkg
MANDIR=$(DESTDIR)/usr/share/man
MAN8DIR=$(MANDIR)/man8

BIN_FILES = vzpkgcache vzyum vzrpm vzpkgadd vzpkgrm vzpkgls
LIB_FILES = functions cache-os myinit
MAN8_FILES = man/vzpkgcache.8 man/vzyum.8 man/vzrpm.8


all: myinit

myinit: init.c
	gcc -O2 -static -s -o $@ $<

clean: clean-distfile
	rm -f myinit

clean-distfile:
	rm -f $(DISTFILE)

install: install-bin install-lib install-man

install-bin: $(BIN_FILES)
	mkdir -p $(BINDIR)
	for f in $(BIN_FILES); do \
		install -m 755 $$f $(BINDIR); \
	done

install-lib: $(LIB_FILES)
	mkdir -p $(LIBDIR)
	for f in $(LIB_FILES); do \
		install -m 644 $$f $(LIBDIR); \
	done

install-man: install-man8
	mkdir -p $(MANDIR)

install-man8: $(MAN8_FILES)
	mkdir -p $(MAN8DIR)
	for f in $(MAN8_FILES); do \
		install -m 644 $$f $(MAN8DIR); \
	done

dist: $(DISTFILE)

$(DISTFILE): clean
	rm -f ../$(NAME)-$(VERSION)
	ln -sf $(NAME) ../$(NAME)-$(VERSION)
	tar -C .. -cvhjf $(DISTFILE) --exclude CVS \
		$(NAME)-$(VERSION)
	rm -f ../$(NAME)-$(VERSION)

rpm: $(DISTFILE)
	rpmbuild -ta $(DISTFILE)


.PHONY: clean clean-distfile install dist
