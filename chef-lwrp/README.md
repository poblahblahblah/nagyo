Nagyo Chef LWRP
===============

This is the Chef LWRP code for Nagyo models

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
  



