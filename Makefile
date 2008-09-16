NAME    = vzpkg2
VERSION = 0.9.4

ETCDIR = /etc/vz
BINDIR  = /usr/bin
SBINDIR = /usr/sbin
LIBDIR  = /usr/share/$(NAME)
MANDIR  = /usr/share/man
MAN5DIR = $(MANDIR)/man5
MAN8DIR = $(MANDIR)/man8

BIN_FILES    = vzpkgcache vzpkgadd vzpkgrm vzpkgupd vzpkgquery vzpkgls vzosname
LIB_FILES    = functions cache-os \
	apt-cache-install apt-cache-update apt-checkupdate apt-functions \
	apt-add apt-query apt-rm apt-update \
	yum-cache-install yum-cache-update yum-checkupdate yum-functions \
	yum-add yum-query yum-rm yum-update
CONFIG_FILES = vzpkg.conf
MAN5_FILES   = man/vzpkg.conf.5
MAN8_FILES   = man/vzpkgcache.8
MYINIT_FILES = myinit.i386 myinit.x86_64 myinit.ia64

SRPMDIR:=$(shell rpm --eval '%{_srcrpmdir}')
RPMDIR:=$(shell rpm --eval '%{_rpmdir}')

DESTDIR:=$(shell pwd)/../dist

$(DESTDIR):
	test -d $@ || mkdir $@

$(DESTDIR)/debian: $(DESTDIR)
	test -d $@ || mkdir $@

$(DESTDIR)/$(NAME): $(DESTDIR)
	test -d $@ || mkdir $@

all:

clean:

install: install-config install-bin install-lib install-myinit install-man

install-config: $(CONFIG_FILES)
	mkdir -p $(DESTDIR)$(ETCDIR)
	for f in $(CONFIG_FILES); do \
		install -m 644 $$f $(DESTDIR)$(ETCDIR); \
	done

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

install-man: install-man5 install-man8
	mkdir -p $(DESTDIR)$(MANDIR)

install-man5: $(MAN5_FILES)
	mkdir -p $(DESTDIR)$(MAN5DIR)
	for f in $(MAN5_FILES); do \
		install -m 644 $$f $(DESTDIR)$(MAN5DIR); \
	done

install-man8: $(MAN8_FILES)
	mkdir -p $(DESTDIR)$(MAN8DIR)
	for f in $(MAN8_FILES); do \
		install -m 644 $$f $(DESTDIR)$(MAN8DIR); \
	done

tar: $(DESTDIR)/$(NAME)
	sed -e "s/@@VERSION@@/$(VERSION)/" < vzpkg.spec.in > vzpkg.spec; \
	rm -f ../$(NAME)-$(VERSION); ln -sf `pwd` ../$(NAME)-$(VERSION) && \
	tar --directory ..  --exclude CVS --exclude .git --exclude \*.tar.bz2 -cvhjf $(DESTDIR)/$(NAME)/$(NAME)-$(VERSION).tar.bz2 $(NAME)-$(VERSION); \
	tar --directory ..  --exclude CVS --exclude .git --exclude \*.tar.bz2 -cvhzf $(DESTDIR)/$(NAME)/$(NAME)-$(VERSION).tar.gz $(NAME)-$(VERSION); \
	rm -f ../$(NAME)-$(VERSION)

rpms: tar
	rpmbuild -ta $(DESTDIR)/$(NAME)/$(NAME)-$(VERSION).tar.bz2
	mv $(SRPMDIR)/$(NAME)-*$(VERSION)*.src.rpm $(DESTDIR)/$(NAME)
	mv $(RPMDIR)/noarch/$(NAME)-*$(VERSION)*.noarch.rpm $(DESTDIR)/$(NAME)

debs: $(DESTDIR)/debian
	fakeroot dpkg-buildpackage -I.git -us -uc
	mv ../$(NAME)*_$(VERSION)* $(DESTDIR)/debian

.PHONY: all install install-bin install-lib install-myinit install-man install-man8 tar debs
