Name:		vzpkg
Version:	2.7.0
Release:	0.2
Summary:	Virtuozzo template management tools
Source:		%{name}.tar.bz2
License:	QPL
Vendor:		SWsoft
Group:		Applications/System
BuildRoot:	%{_tmppath}/%{name}-%{version}-root
BuildArch:	noarch

Requires:	sed, gawk, coreutils
Requires:	vzctl >= 2.7.0-2
# yum<2.2.1 has a bug preventing gpgkeys installation to --installroot.
Requires:	yum >= 2.2.1

%define libdir %_datadir/%name

%description
Virtuozzo template management tools are used for software installation
inside Virtual Environments.


%prep
%setup -n %{name} -q

%build
make

%install
make DESTDIR=%buildroot install

%files
%defattr(-, root, root)
%attr(755,root,root) %_bindir/vzpkgcache
%attr(755,root,root) %_bindir/vzyum
%dir %libdir
%attr(644,root,root) %libdir/functions
%attr(755,root,root) %libdir/cache-os
%attr(755,root,root) %libdir/myinit
%_mandir/man8/vzpkgcache.8.*
%_mandir/man8/vzyum.8.*

%clean
test "x$RPM_BUILD_ROOT" != "x" && rm -rf $RPM_BUILD_ROOT


%changelog
* Tue Mar 24 2005 Kir Kolyshkin <kir.sw.ru> 2.7.0-0.2
- removed -d and -e options from yum calls
- added dependency for yum>=2.2.1
- cache-os now creates/removes symlink to tarball in $TEMPLATE for older vzctl
- use ve-vps.basic.conf-sample as VPS config in cache-os

* Mon Mar 23 2005 Kir Kolyshkin <kir.sw.ru> 2.7.0-0.1
- initially packaged
