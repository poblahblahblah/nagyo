Nagyo Chef LWRP
===============

This is the Chef LWRP code for Nagyo models.

Basic sanity test with test cookbook using a local vagrant vm and nagyo 
server on the host system:

  # start nagyo-server on host system at :3000
  cd nagyo/nagyo-server
  bundle install
  bundle exec rake db:seed
  ./script/rails s

  # install eharmony cookbooks
  cd nagyo/chef-lwrp
  # from tagged tarball ...
  wget http://chefkitchen.corp.eharmony.com/cookbooks/cookbooks-6142.tgz
  tar xzf cookbooks-6142.tgz
  # ... or softlink to local dir
  ln -fs /path/to/dev/cookbooks

  # install nagyo-chef-lwrp to cookbooks dir
  cd nagyo/chef-lwrp
  bundle install
  bundle exec rake install COOKBOOKS=cookbooks

  # this runs chef-solo on vm with test cookbook
  bundle exec vagrant up


Files:
  - libraries/nagyo_helper.rb  ''NagyoHelper''
    - --> cookbooks/base/libraries/nagyo_helper.rb

  - providers/nagyo_helper.rb  
    ''Chef::Provider::EharmonyopsNagyoHelper'', eharmonyops_nagyo_helper
    - --> cookbooks/eharmonyops/providers/nagyo_helper.rb

  - resources/nagios_cluster.rb
    - ''Chef::Resource::EharmonyopsNagiosCluster'', 
      eharmonyops_nagios_cluster { }
    - --> cookbooks/eharmonyops/resources/nagios_cluster.rb
  - resources/nagios_service.rb
    - --> cookbooks/eharmonyops/resources/nagios_service.rb
  



