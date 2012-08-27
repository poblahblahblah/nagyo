@@my_attrs = {
  :nodegroup =>                   {:kind_of => String, :required => true},
  :vip_name =>                    {:kind_of => String, :required => true},
  :vip_dns =>                     {:kind_of => String, :required => true},
  :percent_warn =>                {:kind_of => String, :required => true},
  :percent_crit =>                {:kind_of => String, :required => true},
  :ecv_uri =>                     {:kind_of => String, :required => true},
  :ecv_string =>                  {:kind_of => String, :required => true},
  :contacts =>                    {:kind_of => String, :required => true},
  :check_command =>               {:kind_of => String, :required => false, :default => "check_eh_cluster-http"},
  :notify_on_node_service =>      {:kind_of => String, :required => false, :default => 1},
  :node_check_command =>          {:kind_of => String},
  :node_check_command_arguments =>{:kind_of => String}
}

def initialize(*args)
  super
  @action = :add
  @provider = Chef::Provider::EharmonyopsNagyoHelper
end

actions :add

@@my_attrs.each do |attr, options|
  attribute attr, options
end

attribute :my_attr_keys, :kind_of => Array, :required => false, :default => @@my_attrs.keys
attribute :get_attrs, :kind_of => Array, :required => false, :default => [:nodegroup, :check_command, :contacts, :vip_dns, :vip_name]
attribute :nagyo_url, :required => false
attribute :model_name, :required => false, :default => "vip"
attribute :model_name_plural, :required => false, :default => "vips"
