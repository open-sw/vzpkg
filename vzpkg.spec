Name:		vzpkg2
Version:	0.9.2
Release:	1
Summary:	OpenVZ template management tools
Source:		%{name}-%{version}.tar.bz2
License:	GPL
URL:		http://openvz.org/
Group:		Applications/System
BuildRoot:	%{_tmppath}/%{name}-%{version}-root
BuildArch:	noarch

Requires:	sed, gawk, coreutils
Requires:	procmail
Requires:	vzctl >= 2.7.0-23

# New vzpkg does not work with old template metadata.
Conflicts:	vzpkg
Conflicts:	vztmpl-fedora-core-3
Conflicts:	vztmpl-fedora-core-4
Conflicts:	vztmpl-centos-4
# Since vzpkg-3.0 it requires newer vzrpms
# (the ones with dynamically linked python modules)

%define libdir %_datadir/%name

#avoid stripping
%define __strip /bin/true

%description
OpenVZ template management tools are used for software installation
inside Virtual Environments.


%prep
%setup -n %{name}-%{version}

%install
make DESTDIR=%buildroot install

%files
%defattr(755, root, root)
%attr(755,root,root) %_bindir/vzpkgcache
%attr(755,root,root) %_bindir/vzpkgadd
%attr(755,root,root) %_bindir/vzpkgrm
%attr(755,root,root) %_bindir/vzpkgupd
%attr(755,root,root) %_bindir/vzpkgquery
%attr(755,root,root) %_bindir/vzpkgls
%attr(755,root,root) %_bindir/vzosname
%dir %libdir
%defattr(755, root, root)
%attr(644,root,root) %libdir/functions
%libdir/cache-os
%attr(644,root,root) %libdir/apt-functions
%libdir/apt-checkupdate
%libdir/apt-cache-install
%libdir/apt-cache-update
%libdir/apt-add
%libdir/apt-query
%libdir/apt-rm
%libdir/apt-update
%attr(644,root,root) %libdir/yum-functions
%libdir/yum-cache-install
%libdir/yum-cache-update
%libdir/yum-checkupdate
%libdir/yum-add
%libdir/yum-query
%libdir/yum-rm
%libdir/yum-update
%libdir/myinit.*
%_mandir/man8/vzpkgcache.8.*
%doc README NEWS TODO COPYING

%clean
test "x$RPM_BUILD_ROOT" != "x" && rm -rf $RPM_BUILD_ROOT


%changelog
* Tue Sep  9 2008 Robert Nelson <robertn@the-nelsons.org> 0.9.2
  - Derived from OpenVZ vzpkg.

