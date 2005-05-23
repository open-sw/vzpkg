Name:		vzpkg
Version:	2.7.0
Release:	0.1
Summary:	Virtuozzo template management tools
Source:		%{name}.tar.bz2
License:	QPL
Vendor:		SWsoft
Group:		Applications/System
BuildRoot:	%{_tmppath}/%{name}-%{version}-root
BuildArch:	noarch

Requires:	sed, gawk, coreutils
Requires:	vzctl >= 2.7.0-2

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
* Mon Mar 23 2005 Kir Kolyshkin <kir.sw.ru> 2.7.0-0.1
- initially packaged
