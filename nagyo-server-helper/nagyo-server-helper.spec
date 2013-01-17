# RedHat RPM package spec file
Summary: helper scripts for dealing with Nagyo Server
Name: nagyo-server-helper
# Version: This must be the version string from the rpm filename you plan to 
# use.  This is replaced at rpm build time with NvHelpers::VERSION.
Version: Nagyo::Server::Helper::VERSION
# Release: This is the release number for a package of the same version (ie. if 
# we make a package and find it to be slightly broken and need to make it 
# again, the next package would be release number 2).
Release: 3
# TODO: what license to use?
License: Proprietary
Group: System/Tools
URL: https://github.com/poblahblahblah/nagyo/nagyo-server-helper
#Requires: ruby, rubygem-nokogiri
# NOTE: some of nokogiri reqs only avail via EPEL (Requires: epel-release ?)
Requires: ruby, rubygem-nokogiri, rubygem-activesupport, rubygem-locale
BuildRoot: %{_builddir}/%{name}-buildroot
BuildArch: noarch

%description
This package includes helper scripts for dealing with Nagyo Server

%files
%defattr(-,root,root)
/usr/lib/ruby/site_ruby/1.8/nagyo-server-helper/*.rb
/usr/lib/ruby/site_ruby/1.8/nagyo-server-helper.rb

# 0.0.1-3    2013.01.16
#   - add EPEL dep: rubygem-activesupport, rubygem-locale
#
# 0.0.1-2    2013.01.16
#   - add rpm dep: rubygem-nokogiri
#
# 0.0.1-1
#   - initial version
