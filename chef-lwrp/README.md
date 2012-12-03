Nagyo Chef LWRP
===============

This is the Chef LWRP code for Nagyo models.

Basic sanity test with test cookbook using a local vagrant vm and nagyo 
server on the host system:

```sh
    # start nagyo-server on host system at :3000
    cd nagyo/nagyo-server
    bundle
    bundle exec rake db:seed
    ./script/rails s

    # install eharmony cookbooks
    cd nagyo/chef-lwrp
    # from tagged tarball ...
    wget http://chefkitchen.corp.eharmony.com/cookbooks/cookbooks-6142.tgz
    tar xzf cookbooks-6142.tgz
    # ... or softlink to local dir
    ln -fs /path/to/dev/cookbooks

    # build nagyo-server-helper gem and copy to cookbooks for installation on test vm
    cd nagyo/nagyo-server-helper
    bundle
    bundle exec rake build
    cp pkg/nagyo-server-helper-0.0.1.gem ../chef-lwrp/cookbooks/.

    # install nagyo-chef-lwrp to cookbooks dir
    cd nagyo/chef-lwrp
    bundle
    bundle exec rake install COOKBOOKS=cookbooks

    # bring up a VM (chef-solo will likely fail)
    bundle exec vagrant up

    # ssh in to VM and install nagyo helper
    bundle exec vagrant ssh
      % sudo gem install /vagrant/cookbooks/nagyo-server-helper-0.0.1.gem

    # re-run chef-solo on vm with test cookbook
    bundle exec vagrant provision
```


Files
-----
* libraries/nagyo_helper.rb  `NagyoHelper`
    * --> cookbooks/base/libraries/nagyo_helper.rb
* providers/nagyo_helper.rb   
    * `Chef::Provider::EharmonyopsNagyoHelper`, 
      `eharmonyops_nagyo_helper`
    * --> cookbooks/eharmonyops/providers/nagyo_helper.rb
* resources/nagios_cluster.rb
    * `Chef::Resource::EharmonyopsNagiosCluster`, 
      `eharmonyops_nagios_cluster`
    * --> cookbooks/eharmonyops/resources/nagios_cluster.rb
* resources/nagios_service.rb
    * --> cookbooks/eharmonyops/resources/nagios_service.rb
