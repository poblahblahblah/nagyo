# RedHat RPM tasks for rake

require 'nagyo-server-helper/version'

BUILD_VERSION = Nagyo::Server::Helper::VERSION
BUILDROOT = '/tmp/nagyo-server-helper-buildroot/'

desc 'Build an etch client RPM on a Red Hat box'
task :redhat => [:redhatprep, :rpm]


desc 'Prep a Red Hat box for building an RPM'
task :redhatprep do
  # Install the package which contains the rpmbuild command
  system('rpm --quiet -q rpm-build || sudo yum install rpm-build')
end


desc 'Build an etch client RPM'
task :rpm do
  #
  # Create package file structure in build root
  #

  rm_rf(BUILDROOT)
  libdir = File.join(BUILDROOT, 'usr', 'lib', 'ruby', 'site_ruby', '1.8', 'nagyo-server-helper')
  mkdir_p(libdir)

  # copy files from lib/ up into nv_helpers level for ruby site lib
  (Dir.glob("lib/**/*rb") - ["lib/nagyo-server-helper.rb"]).each do |f|
    cp(f, libdir)
  end
  # do this file separately - it loads the others
  cp('lib/nagyo-server-helper.rb', File.dirname(libdir))

  #
  # Prep spec file
  #
  spec = Tempfile.new('nagyo-server-helper-rpm')
  IO.foreach('nagyo-server-helper.spec') do |line|
    # add the NvHelpers::VERSION constant to rpm spec file
    line.gsub!(/^Version: .*$/,
               "Version: #{BUILD_VERSION}")
    spec.puts(line)
  end
  spec.close

  #
  # Build the package
  #

  system("rpmbuild -bb --buildroot #{BUILDROOT} #{spec.path}") or warn("rpm.rake: Unable to execute rpmbuild! ERROR: #{$?}")

  #
  # Cleanup
  #
  rm_rf(BUILDROOT)
end
