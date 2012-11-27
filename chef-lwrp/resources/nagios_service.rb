@@my_attrs = {
  # TODO: nodegroup -> hostgroup ?
  :nodegroup =>                     {:kind_of => String,  :required => true},
  :name =>                          {:kind_of => String,  :required => true},
  :check_command =>                 {:kind_of => String,  :required => true},
  :check_command_arguments =>       {:kind_of => String,  :required => true},
  :contacts =>                      {:kind_of => String,  :required => true},

  :check_period  =>                 {:kind_of => String,  :required => false, :default => "24x7"},
  :max_check_attempts =>            {:kind_of => Integer, :required => false, :default => 3},
  :check_interval =>                {:kind_of => Integer, :required => false, :default => 3},
  :retry_interval =>                {:kind_of => Integer, :required => false, :default => 3},
  :notification_interval =>         {:kind_of => Integer, :required => false, :default => 60},
  :notification_period =>           {:kind_of => String,  :required => false, :default => "24x7"},
  :service_description =>           {:kind_of => String,  :required => false},
  :display_name =>                  {:kind_of => String,  :required => false},
  :servicegroups =>                 {:kind_of => String,  :required => false},
  :is_volatile =>                   {:kind_of => Integer, :required => false, :default => 0},
  :initial_state =>                 {:kind_of => String,  :required => false},
  :active_checks_enabled =>         {:kind_of => Integer, :required => false, :default => 1},
  :passive_checks_enabled =>        {:kind_of => Integer, :required => false, :default => 1},
  :obsess_over_service =>           {:kind_of => Integer, :required => false, :default => 0},
  :check_freshness =>               {:kind_of => Integer, :required => false, :default => 0},
  :freshness_threshold =>           {:kind_of => Integer, :required => false, :default => 1200},
  :event_handler =>                 {:kind_of => String,  :required => false},
  :event_handler_enabled =>         {:kind_of => Integer, :required => false, :default => 0},
  :low_flap_threshold =>            {:kind_of => Integer, :required => false},
  :high_flap_threshold =>           {:kind_of => Integer, :required => false},
  :flap_detection_enabled =>        {:kind_of => Integer, :required => false,  :default => 0},
  :flap_detection_options =>        {:kind_of => String,  :required => false},
  :process_perf_data =>             {:kind_of => Integer, :required => false, :default => 0},
  :retain_status_information =>     {:kind_of => Integer, :required => false, :default => 1},
  :retain_nonstatus_information =>  {:kind_of => Integer, :required => false, :default => 1},
  :first_notification_delay =>      {:kind_of => Integer, :required => false},
  :notification_options  =>         {:kind_of => String,  :required => false},
  :notifications_enabled =>         {:kind_of => Integer, :required => false},
  :stalking_options =>              {:kind_of => String,  :required => false},
  :register =>                      {:kind_of => Integer, :required => false, :default => 1},
  :notes =>                         {:kind_of => String,  :required => false},
  :notes_url =>                     {:kind_of => String,  :required => false},
  :action_url =>                    {:kind_of => String,  :required => false}
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
#[:nodegroup, :check_command, :contacts, :notification_period]
attribute :get_attrs, :kind_of => Array, :required => false, :default => [:name]
attribute :nagyo_url, :required => false
attribute :model_name, :required => false, :default => "service"
attribute :model_name_plural, :required => false, :default => "services"
