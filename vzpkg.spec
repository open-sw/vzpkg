Name:		vzpkg
Version:	2.7.0
Release:	0.9
Summary:	Open Virtuozzo template management tools
Source:		%{name}-%{version}.tar.bz2
License:	QPL
Vendor:		SWsoft
Group:		Applications/System
BuildRoot:	%{_tmppath}/%{name}-%{version}-root
BuildArch:	noarch

Requires:	sed, gawk, coreutils
Requires:	vzctl >= 2.7.0-6
# yum<2.2.1 has a bug preventing gpgkeys installation to --installroot.
Requires:	yum >= 2.2.1

%define libdir %_datadir/%name

%description
Open Virtuozzo template management tools are used for software installation
inside Virtual Private Servers.


%prep
%setup 

%build
make

%install
make DESTDIR=%buildroot install

%files
%defattr(-, root, root)
%attr(755,root,root) %_bindir/vzpkgcache
%attr(755,root,root) %_bindir/vzyum
%attr(755,root,root) %_bindir/vzrpm
%attr(755,root,root) %_bindir/vzpkgadd
%attr(755,root,root) %_bindir/vzpkgrm
%attr(755,root,root) %_bindir/vzpkgls
%dir %libdir
%attr(644,root,root) %libdir/functions
%attr(755,root,root) %libdir/cache-os
%attr(755,root,root) %libdir/myinit
%_mandir/man8/vzpkgcache.8.*
%_mandir/man8/vzyum.8.*
%_mandir/man8/vzrpm.8.*

%clean
test "x$RPM_BUILD_ROOT" != "x" && rm -rf $RPM_BUILD_ROOT


%changelog
* Thu Jul 14 2005 Kir Kolyshkin <kir@sw.ru> 2.7.0-0.9
- fixed order of 'find' arguments to avoid warnings
- added 'dist' and 'rpm' targets to Makefile

* Wed Jun 22 2005 Kir Kolyshkin <kir@sw.ru> 2.7.0-0.8
- added -q, -o options to vzpkgls (for compatibility only)

* Wed Jun 22 2005 Kir Kolyshkin <kir@sw.ru> 2.7.0-0.7
- added vzpkgls utility

* Tue Jun 21 2005 Kir Kolyshkin <kir@sw.ru> 2.7.0-0.6
- removed workaround for old vzctl which expect cache tarball in /vz/template
- require newer vzctl which gets cache from /vz/template/cache

* Tue Jun 21 2005 Kir Kolyshkin <kir@sw.ru> 2.7.0-0.5
- fixed vzrpm (use --root not --installroot for rpm)

* Tue Jun 21 2005 Kir Kolyshkin <kir@sw.ru> 2.7.0-0.4
- added -f|--force option to vzpkgadd/vzpkgrm
- added ability to install gpgkeys from config/gpgkeys if available, as yum currently can not handle
  more that one gpgkey per repo

* Wed Jun  8 2005 Kir Kolyshkin <kir.sw.ru> 2.7.0-0.3
- added vzrpm wrapper
- added simple vzpkgadd/vzpkgrm wrappers (w/out man pages)
- right name is 'Open Virtuozzo'

* Tue Mar 24 2005 Kir Kolyshkin <kir.sw.ru> 2.7.0-0.2
- removed -d and -e options from yum calls
- added dependency for yum>=2.2.1
- cache-os now creates/removes symlink to tarball in $TEMPLATE for older vzctl
- use ve-vps.basic.conf-sample as VPS config in cache-os

* Mon Mar 23 2005 Kir Kolyshkin <kir.sw.ru> 2.7.0-0.1
- initially packaged
