# RailsAdmin config file. Generated on September 19, 2012 12:46
# See github.com/sferik/rails_admin for more informations

# add our form inputs 
RailsAdmin::Config::Fields::Types::register(:nagios_options, NagiosOptionsInput)


RailsAdmin.config do |config|

  # If your default_local is different from :en, uncomment the following 2 lines and set your default locale here:
  # require 'i18n'
  # I18n.default_locale = :de

  config.current_user_method { current_user } # auto-generated

  # If you want to track changes on your models:
  # config.audit_with :history, User

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, User

  # Set the admin name here (optional second array element will appear in a beautiful RailsAdmin red ©)
  config.main_app_name = ['Nagyo', 'Admin']
  # or for a dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }


  #  ==> Global show view settings
  # Display empty fields in show views
  # config.compact_show_view = false

  #  ==> Global list view settings
  # Number of default rows per-page:
  # config.default_items_per_page = 20

  #  ==> Included models
  # Add all excluded models here:
  # config.excluded_models = [Cluster, Command, Contact, Contactgroup, Hardwareprofile, Host, Hostdependency, Hostescalation, Hostgroup, Service, Servicedependency, Serviceescalation, Servicegroup, Timeperiod, User]

  # Add models here if you want to go 'whitelist mode':
  # config.included_models = [Cluster, Command, Contact, Contactgroup, Hardwareprofile, Host, Hostdependency, Hostescalation, Hostgroup, Service, Servicedependency, Serviceescalation, Servicegroup, Timeperiod, User]

  # Application wide tried label methods for models' instances
  config.label_methods << :description # Default is [:name, :title]
  config.label_methods << :to_s

  #  ==> Global models configuration
  # config.models do
  #   # Configuration here will affect all included models in all scopes, handle with care!
  #
  #   list do
  #     # Configuration here will affect all included models in list sections (same for show, export, edit, update, create)
  #
  #     fields_of_type :date do
  #       # Configuration here will affect all date fields, in the list section, for all included models. See README for a comprehensive type list.
  #     end
  #   end
  # end
  #
  #  ==> Model specific configuration
  # Keep in mind that *all* configuration blocks are optional.
  # RailsAdmin will try his best to provide the best defaults for each section, for each field.
  # Try to override as few things as possible, in the most generic way. Try to avoid setting labels for models and attributes, use ActiveRecord I18n API instead.
  # Less code is better code!
  # config.model MyModel do
  #   # Cross-section field configuration
  #   object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #   label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #   label_plural 'My models'      # Same, plural
  #   weight -1                     # Navigation priority. Bigger is higher.
  #   parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #   navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  #   # Section specific configuration:
  #   list do
  #     filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #     items_per_page 100    # Override default_items_per_page
  #     sort_by :id           # Sort column (default is primary key)
  #     sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     # Here goes the fields configuration for the list view
  #   end
  # end

  # Your model's configuration, to help you get started:

  # All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible. (visible(true))

  config.model Cluster do
  #   # Found associations:
  #     configure :contacts, :has_and_belongs_to_many_association
  #     configure :check_command, :belongs_to_association
  #     configure :node_check_command, :belongs_to_association
  #     configure :hostgroup, :belongs_to_association   #
  #   # Found columns:
  #     configure :_type, :text         # Hidden
  #     configure :_id, :bson_object_id
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :contact_ids, :serialized         # Hidden
  #     configure :check_command_id, :bson_object_id         # Hidden
  #     configure :node_check_command_id, :bson_object_id         # Hidden
  #     configure :hostgroup_id, :bson_object_id         # Hidden
  #     configure :vip_name, :text 
  #     configure :vip_dns, :text 
  #     configure :node_alert_when_down, :text 
  #     configure :percent_warn, :text 
  #     configure :percent_crit, :text 
  #     configure :ecv_uri, :text 
  #     configure :ecv_string, :text 
  #     configure :check_command_arguments, :text 
  #     configure :node_check_command_arguments, :text 
  #     configure :notify_on_node_service, :integer   #   # Sections:
    list do
      field :vip_name
      field :vip_dns
      field :hostgroup
      field :contacts
      field :percent_warn
      field :percent_crit
      field :check_command
      field :check_command_arguments
      field :ecv_uri
    end
  #   export do; end
  #   show do; end
    edit do
      field :vip_name
      field :vip_dns
      field :hostgroup
      field :check_command
      field :check_command_arguments
      field :contacts
      field :percent_warn
      field :percent_crit
      field :ecv_uri
      field :ecv_string

      field :node_alert_when_down, :boolean
      field :notify_on_node_service, :boolean
      field :node_check_command
      field :node_check_command_arguments
    end
  #   create do; end
  #   update do; end
  end

  config.model Command do
  #   # Found associations:
  #     configure :hosts, :has_and_belongs_to_many_association 
  #     configure :hardwareprofiles, :has_and_belongs_to_many_association 
  #     configure :host_notification_contacts, :has_many_association 
  #     configure :service_notification_contacts, :has_many_association 
  #     configure :check_command_clusters, :has_many_association 
  #     configure :node_check_command_clusters, :has_many_association 
  #     configure :check_command_services, :has_many_association 
  #     configure :event_handler_services, :has_many_association   #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :command_name, :text 
  #     configure :command_line, :text 
  #     configure :host_ids, :serialized         # Hidden 
  #     configure :hardwareprofile_ids, :serialized         # Hidden   #   # Sections:
    list do
      field :command_name
      field :command_line
    end
  #   export do; end
  #   show do; end
    edit do
      field :command_name
      field :command_line
    end
  #   create do; end
  #   update do; end
  end

  config.model Contact do
  #   # Found associations:
  #     configure :clusters, :has_and_belongs_to_many_association 
  #     configure :hardwareprofiles, :has_and_belongs_to_many_association 
  #     configure :hosts, :has_and_belongs_to_many_association 
  #     configure :hostescalations, :has_and_belongs_to_many_association 
  #     configure :services, :has_and_belongs_to_many_association 
  #     configure :serviceescalations, :has_and_belongs_to_many_association 
  #     configure :host_notification_commands, :has_and_belongs_to_many_association 
  #     configure :service_notification_commands, :has_and_belongs_to_many_association 
  #     configure :contact_groups, :has_and_belongs_to_many_association 
  #     configure :host_notification_period, :belongs_to_association 
  #     configure :service_notification_period, :belongs_to_association   #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :cluster_ids, :serialized         # Hidden 
  #     configure :hardwareprofile_ids, :serialized         # Hidden 
  #     configure :host_ids, :serialized         # Hidden 
  #     configure :hostescalation_ids, :serialized         # Hidden 
  #     configure :service_ids, :serialized         # Hidden 
  #     configure :serviceescalation_ids, :serialized         # Hidden 
  #     configure :host_notification_command_ids, :serialized         # Hidden 
  #     configure :service_notification_command_ids, :serialized         # Hidden 
  #     configure :contact_group_ids, :serialized         # Hidden 
  #     configure :host_notification_period_id, :bson_object_id         # Hidden 
  #     configure :service_notification_period_id, :bson_object_id         # Hidden 
  #     configure :contact_name, :text 
  #     configure :email, :text 
  #     configure :host_notifications_enabled, :integer 
  #     configure :service_notifications_enabled, :integer 
  #     configure :host_notification_options, :text 
  #     configure :service_notification_options, :text 
  #     configure :alias, :text 
  #     configure :pager, :text 
  #     configure :addressx, :text 
  #     configure :can_submit_commands, :integer 
  #     configure :retain_status_information, :integer 
  #     configure :retain_nonstatus_information, :integer   #   # Sections:
    list do
      field :contact_name
      field :email
      field :host_notifications_enabled
      field :service_notifications_enabled
      field :host_notification_period
      field :service_notification_period
      field :host_notification_options
      field :service_notification_options
      field :host_notification_commands
      field :service_notification_commands
    end
  #   export do; end
  #   show do; end
    edit do
      field :contact_name
      field :email
      field :host_notifications_enabled
      field :service_notifications_enabled
      field :host_notification_period
      field :service_notification_period

      field :host_notification_options, :nagios_options
      field :service_notification_options, :nagios_options
      #do #, :enum
      #  partial "test"
      #end
      field :host_notification_commands
      field :service_notification_commands

      field :alias
      field :contact_groups
      field :pager
      field :addressx
      field :can_submit_commands, :boolean
      field :retain_status_information, :boolean
      field :retain_nonstatus_information, :boolean
    end
  #   create do; end
  #   update do; end
  end

  config.model Contactgroup do
  #   # Found associations:
  #     configure :members, :has_and_belongs_to_many_association 
  #     configure :contactgroup_members, :has_and_belongs_to_many_association 
  #     configure :hosts, :has_and_belongs_to_many_association 
  #     configure :hostescalations, :has_and_belongs_to_many_association 
  #     configure :serviceescalations, :has_and_belongs_to_many_association   #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :member_ids, :serialized         # Hidden 
  #     configure :contactgroup_member_ids, :serialized         # Hidden 
  #     configure :host_ids, :serialized         # Hidden 
  #     configure :hostescalation_ids, :serialized         # Hidden 
  #     configure :serviceescalation_ids, :serialized         # Hidden 
  #     configure :contactgroup_name, :text 
  #     configure :alias, :text   #   # Sections:
    list do
      field :contactgroup_name
      #field :alias
      field :members
      field :contactgroup_members
    end
  #   export do; end
  #   show do; end
    edit do
      field :contactgroup_name
      #field :alias
      field :members
      field :contactgroup_members
    end
  #   create do; end
  #   update do; end
  end

  config.model Hardwareprofile do
  #   # Found associations:
  #     configure :contacts, :has_and_belongs_to_many_association 
  #     configure :check_commands, :has_and_belongs_to_many_association   #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :contact_ids, :serialized         # Hidden 
  #     configure :check_command_ids, :serialized         # Hidden 
  #     configure :hardware_profile, :text   #   # Sections:
    list do
      field :hardware_profile
      field :contacts
      field :check_commands
    end
  #   export do; end
  #   show do; end
    edit do
      field :hardware_profile
      field :contacts
      field :check_commands
    end
  #   create do; end
  #   update do; end
  end

  config.model Host do
  #   # Found associations:
  #     configure :parents, :has_and_belongs_to_many_association 
  #     configure :contacts, :has_and_belongs_to_many_association 
  #     configure :hostgroups, :has_and_belongs_to_many_association 
  #     configure :contact_groups, :has_and_belongs_to_many_association 
  #     configure :check_command, :belongs_to_association 
  #     configure :event_handler, :belongs_to_association 
  #     configure :check_period, :belongs_to_association 
  #     configure :notification_period, :belongs_to_association 
  #     configure :host_dependencies, :has_many_association 
  #     configure :dependent_host_dependencies, :has_many_association 
  #     configure :services, :has_many_association 
  #     configure :service_dependencies, :has_many_association 
  #     configure :dependent_service_dependencies, :has_many_association 
  #     configure :hostescalations, :has_many_association 
  #     configure :serviceescalations, :has_many_association   #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :parent_ids, :serialized         # Hidden 
  #     configure :contact_ids, :serialized         # Hidden 
  #     configure :hostgroup_ids, :serialized         # Hidden 
  #     configure :contact_group_ids, :serialized         # Hidden 
  #     configure :check_command_id, :bson_object_id         # Hidden 
  #     configure :event_handler_id, :bson_object_id         # Hidden 
  #     configure :check_period_id, :bson_object_id         # Hidden 
  #     configure :notification_period_id, :bson_object_id         # Hidden 
  #     configure :host_name, :text 
  #     configure :alias, :text 
  #     configure :address, :text 
  #     configure :max_check_attempts, :integer 
  #     configure :notification_interval, :integer 
  #     configure :notes, :text 
  #     configure :notes_url, :text 
  #     configure :action_url, :text 
  #     configure :display_name, :text 
  #     configure :initial_state, :text 
  #     configure :check_interval, :integer 
  #     configure :retry_interval, :integer 
  #     configure :active_checks_enabled, :integer 
  #     configure :passive_checks_enabled, :integer 
  #     configure :obsess_over_host, :integer 
  #     configure :check_freshness, :integer 
  #     configure :freshness_threshold, :integer 
  #     configure :event_handler_enabled, :integer 
  #     configure :low_flap_threshold, :integer 
  #     configure :high_flap_threshold, :integer 
  #     configure :flap_detection_enabled, :integer 
  #     configure :flap_detection_options, :text 
  #     configure :process_perf_data, :integer 
  #     configure :retain_status_information, :integer 
  #     configure :retain_nonstatus_information, :integer 
  #     configure :first_notification_delay, :integer 
  #     configure :notification_options, :text 
  #     configure :notifications_enabled, :integer 
  #     configure :stalking_options, :text 
  #     configure :icon_image, :text 
  #     configure :icon_image_alt, :text 
  #     configure :vrml_image, :text 
  #     configure :statusmap_image, :text   #   # Sections:
    list do
      field :host_name
      field :address
      field :contacts
      field :max_check_attempts
      field :check_period
      field :notification_interval
      field :notification_period
    end
  #   export do; end
  #   show do; end
    edit do
      field :host_name
      field :address
      field :contacts
      field :max_check_attempts # 1..5
      field :check_period
      field :notification_interval # 1..5
      field :notification_period

      field :display_name
      field :parents     # :collection => Host.all, :member_label => :host_name
      field :hostgroups
      field :contact_groups
      field :check_command
      field :initial_state, :nagios_options
      field :check_interval #, :as => :select, :collection => [ 1, 2, 3, 4, 5 ]
      field :retry_interval #, :as => :select, :collection => [ 1, 2, 3, 4, 5 ]
      field :active_checks_enabled, :boolean
      field :passive_checks_enabled, :boolean
      field :obsess_over_host, :boolean
      field :check_freshness, :boolean
      field :freshness_threshold #, :as => :select, :collection => [ 1, 2, 3, 4, 5 ]
      field :event_handler
      field :event_handler_enabled, :boolean
      field :low_flap_threshold #, :as => :select, :collection => [ 1, 2, 3, 4, 5 ]
      field :high_flap_threshold #, :as => :select, :collection => [ 1, 2, 3, 4, 5 ]
      field :flap_detection_enabled, :boolean
      field :flap_detection_options, :nagios_options
      field :process_perf_data, :boolean
      field :retain_status_information, :boolean
      field :retain_nonstatus_information, :boolean
      field :first_notification_delay #, :as => :select, :collection => [ 1, 2, 3, 4, 5 ] 
      field :notification_options, :nagios_options
      field :notifications_enabled, :boolean
      field :stalking_options, :nagios_options
      field :notes
      field :notes_url
      field :action_url
      field :icon_image
      field :icon_image_alt
      field :vrml_image
      field :statusmap_image
    end
  #   create do; end
  #   update do; end
  end

  config.model Hostdependency do
  #   # Found associations:
  #     configure :dependency_period, :belongs_to_association 
  #     configure :host, :belongs_to_association 
  #     configure :dependent_host, :belongs_to_association 
  #     configure :hostgroup, :belongs_to_association 
  #     configure :dependent_hostgroup, :belongs_to_association   #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :dependency_period_id, :bson_object_id         # Hidden 
  #     configure :host_id, :bson_object_id         # Hidden 
  #     configure :dependent_host_id, :bson_object_id         # Hidden 
  #     configure :hostgroup_id, :bson_object_id         # Hidden 
  #     configure :dependent_hostgroup_id, :bson_object_id         # Hidden 
  #     configure :members, :serialized 
  #     configure :inherits_parent, :integer 
  #     configure :execution_failure_criteria, :text 
  #     configure :notification_failure_criteria, :text 
  #     configure :dependent_host_name, :text 
  #     configure :host_name, :text 
  #     configure :dependent_hostgroup_name, :text 
  #     configure :hostgroup_name, :text   #   # Sections:
    list do
      field :host
      field :hostgroup
      field :dependent_host
      field :dependent_hostgroup
      field :dependency_period
    end
  #   export do; end
  #   show do; end
    edit do
      field :host
      field :hostgroup
      field :dependent_host
      field :dependent_hostgroup

      field :inherits_parent, :boolean
      field :execution_failure_criteria, :nagios_options
      field :notification_failure_criteria, :nagios_options
      field :dependency_period
    end
  #   create do; end
  #   update do; end
  end

  config.model Hostescalation do
  #   # Found associations:
  #     configure :host, :belongs_to_association 
  #     configure :hostgroup, :belongs_to_association 
  #     configure :contacts, :has_and_belongs_to_many_association 
  #     configure :contact_groups, :has_and_belongs_to_many_association 
  #     configure :escalation_period, :belongs_to_association   #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :host_id, :bson_object_id         # Hidden 
  #     configure :hostgroup_id, :bson_object_id         # Hidden 
  #     configure :contact_ids, :serialized         # Hidden 
  #     configure :contact_group_ids, :serialized         # Hidden 
  #     configure :escalation_period_id, :bson_object_id         # Hidden 
  #     configure :first_notification, :integer 
  #     configure :last_notification, :integer 
  #     configure :notification_interval, :integer 
  #     configure :escalation_options, :text 
  #     configure :host_name, :text 
  #     configure :hostgroup_name, :text   #   # Sections:
    list do
      field :host
      field :hostgroup
      field :first_notification
      field :last_notification
      field :contacts
    end
  #   export do; end
  #   show do; end
    edit do
      field :host
      field :hostgroup
      field :contacts
      field :contact_groups
      field :first_notification
      field :last_notification
      field :notification_interval
      field :escalation_period
      field :escalation_options, :nagios_options # d u r
    end
  #   create do; end
  #   update do; end
  end

  config.model Hostgroup do
  #   # Found associations:
  #     configure :members, :has_and_belongs_to_many_association 
  #     configure :hostgroup_members, :has_and_belongs_to_many_association 
  #     configure :host_dependencies, :has_many_association 
  #     configure :dependent_host_dependencies, :has_many_association 
  #     configure :service_dependencies, :has_many_association 
  #     configure :dependent_service_dependencies, :has_many_association 
  #     configure :clusters, :has_many_association 
  #     configure :services, :has_many_association 
  #     configure :hostescalations, :has_many_association 
  #     configure :serviceescalations, :has_many_association   #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :member_ids, :serialized         # Hidden 
  #     configure :hostgroup_member_ids, :serialized         # Hidden 
  #     configure :hostgroup_name, :text 
  #     configure :alias, :text 
  #     configure :notes, :text 
  #     configure :notes_url, :text 
  #     configure :action_url, :text   #   # Sections:
    list do
      field :hostgroup_name
      field :alias
      field :notes
      field :notes_url
      field :action_url
    end
  #   export do; end
  #   show do; end
    edit do
      field :hostgroup_name
      field :alias

      field :members
      field :hostgroup_members

      field :notes
      field :notes_url
      field :action_url
    end
  #   create do; end
  #   update do; end
  end

  config.model Service do
  #   # Found associations:
  #     configure :host, :belongs_to_association 
  #     configure :hostgroup, :belongs_to_association 
  #     configure :contacts, :has_and_belongs_to_many_association 
  #     configure :check_command, :belongs_to_association 
  #     configure :event_handler, :belongs_to_association 
  #     configure :check_period, :belongs_to_association 
  #     configure :notification_period, :belongs_to_association 
  #     configure :servicegroups, :has_and_belongs_to_many_association 
  #     configure :service_dependencies, :has_many_association 
  #     configure :dependent_service_dependencies, :has_many_association 
  #     configure :serviceescalations, :has_many_association   #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :host_id, :bson_object_id         # Hidden 
  #     configure :hostgroup_id, :bson_object_id         # Hidden 
  #     configure :contact_ids, :serialized         # Hidden 
  #     configure :check_command_id, :bson_object_id         # Hidden 
  #     configure :event_handler_id, :bson_object_id         # Hidden 
  #     configure :check_period_id, :bson_object_id         # Hidden 
  #     configure :notification_period_id, :bson_object_id         # Hidden 
  #     configure :servicegroup_ids, :serialized         # Hidden 
  #     configure :name, :string 
  #     configure :check_command_arguments, :text 
  #     configure :max_check_attempts, :integer 
  #     configure :check_interval, :integer 
  #     configure :retry_interval, :integer 
  #     configure :notification_interval, :integer 
  #     configure :service_description, :text 
  #     configure :display_name, :text 
  #     configure :is_volatile, :integer 
  #     configure :initial_state, :text 
  #     configure :active_checks_enabled, :integer 
  #     configure :passive_checks_enabled, :integer 
  #     configure :obsess_over_service, :integer 
  #     configure :check_freshness, :integer 
  #     configure :freshness_threshold, :integer 
  #     configure :event_handler_enabled, :integer 
  #     configure :low_flap_threshold, :integer 
  #     configure :high_flap_threshold, :integer 
  #     configure :flap_detection_enabled, :integer 
  #     configure :flap_detection_options, :text 
  #     configure :process_perf_data, :integer 
  #     configure :retain_status_information, :integer 
  #     configure :retain_nonstatus_information, :integer 
  #     configure :first_notification_delay, :integer 
  #     configure :notification_options, :text 
  #     configure :notifications_enabled, :integer 
  #     configure :stalking_options, :text 
  #     configure :register, :integer 
  #     configure :notes, :text 
  #     configure :notes_url, :text 
  #     configure :action_url, :text 
  #     configure :icon_image, :text 
  #     configure :icon_image_alt, :text 
  #     configure :host_name, :serialized 
  #     configure :hostgroup_name, :serialized   #   # Sections:
    list do
      field :name
      field :host
      field :hostgroup
      field :contacts
      field :check_command
      field :check_command_arguments
      field :check_period
      field :notification_period
    end
  #   export do; end
  #   show do; end
    edit do
      field :host
      field :hostgroup
      field :contacts
      field :check_command
      field :check_command_arguments
      field :max_check_attempts
      field :check_interval
      field :retry_interval
      field :notification_interval
      field :check_period
      field :notification_period

      field :display_name
      field :servicegroups
      field :is_volatile, :boolean
      field :initial_state, :nagios_options # o w u c

      field  :active_checks_enabled, :boolean
      field  :passive_checks_enabled, :boolean
      field  :obsess_over_service, :boolean
      field  :check_freshness, :boolean
      field  :freshness_threshold
      field  :event_handler
      field  :event_handler_enabled, :boolean
      field  :low_flap_threshold
      field  :high_flap_threshold
      field  :flap_detection_enabled, :boolean
      field  :flap_detection_options, :nagios_options
      field  :process_perf_data, :boolean
      field  :retain_status_information, :boolean
      field  :retain_nonstatus_information, :boolean
      field  :first_notification_delay #, :as => :select, :collection => [ 1, 2, 3, 4, 5]
      field  :notification_options, :nagios_options
      field  :notifications_enabled, :boolean
      field  :stalking_options, :nagios_options # (o w u c)
      field  :register, :boolean
      field  :notes
      field  :notes_url
      field  :action_url
      field  :icon_image
      field  :icon_image_alt
    end
  #   create do; end
  #   update do; end
  end

  config.model Servicedependency do
  #   # Found associations:
  #     configure :host, :belongs_to_association 
  #     configure :hostgroup, :belongs_to_association 
  #     configure :service, :belongs_to_association 
  #     configure :dependent_host, :belongs_to_association 
  #     configure :dependent_hostgroup, :belongs_to_association 
  #     configure :dependent_service, :belongs_to_association 
  #     configure :dependency_period, :belongs_to_association   #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :host_id, :bson_object_id         # Hidden 
  #     configure :hostgroup_id, :bson_object_id         # Hidden 
  #     configure :service_id, :bson_object_id         # Hidden 
  #     configure :dependent_host_id, :bson_object_id         # Hidden 
  #     configure :dependent_hostgroup_id, :bson_object_id         # Hidden 
  #     configure :dependent_service_id, :bson_object_id         # Hidden 
  #     configure :dependency_period_id, :bson_object_id         # Hidden 
  #     configure :dependent_service_description, :text 
  #     configure :service_description, :text 
  #     configure :inherits_parent, :integer 
  #     configure :execution_failure_criteria, :text 
  #     configure :notification_failure_criteria, :text 
  #     configure :dependent_host_name, :text 
  #     configure :host_name, :text 
  #     configure :dependent_hostgroup_name, :text 
  #     configure :hostgroup_name, :text   #   # Sections:
    list do
      field :host
      field :hostgroup
      field :service
      field :dependent_host
      field :dependent_hostgroup
      field :dependent_service
      field :dependency_period
    end
  #   export do; end
  #   show do; end
    edit do
      field :host
      field :hostgroup
      field :service
      field :dependent_host
      field :dependent_hostgroup
      field :dependent_service

      field :inherits_parent, :boolean
      field :execution_failure_criteria, :nagios_options
      field :notification_failure_criteria, :nagios_options
      field :dependency_period
    end
  #   create do; end
  #   update do; end
  end

  config.model Serviceescalation do
  #   # Found associations:
  #     configure :host, :belongs_to_association 
  #     configure :hostgroup, :belongs_to_association 
  #     configure :service, :belongs_to_association 
  #     configure :contacts, :has_and_belongs_to_many_association 
  #     configure :contact_groups, :has_and_belongs_to_many_association 
  #     configure :escalation_period, :belongs_to_association   #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :host_id, :bson_object_id         # Hidden 
  #     configure :hostgroup_id, :bson_object_id         # Hidden 
  #     configure :service_id, :bson_object_id         # Hidden 
  #     configure :contact_ids, :serialized         # Hidden 
  #     configure :contact_group_ids, :serialized         # Hidden 
  #     configure :escalation_period_id, :bson_object_id         # Hidden 
  #     configure :first_notification, :integer 
  #     configure :last_notification, :integer 
  #     configure :notification_interval, :integer 
  #     configure :escalation_options, :text 
  #     configure :host_name, :text 
  #     configure :hostgroup_name, :text 
  #     configure :service_description, :text   #   # Sections:
    list do
      field :host
      field :hostgroup
      field :service
      field :first_notification
      field :last_notification
      field :contacts
    end
  #   export do; end
  #   show do; end
    edit do
      field :host
      field :hostgroup
      field :service
      field :contacts
      field :contact_groups
      field :first_notification
      field :last_notification
      field :notification_interval
      field :escalation_period
      field :escalation_options, :nagios_options
    end
  #   create do; end
  #   update do; end
  end

  config.model Servicegroup do
  #   # Found associations:
  #     configure :members, :has_and_belongs_to_many_association 
  #     configure :servicegroup_members, :has_and_belongs_to_many_association   #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :member_ids, :serialized         # Hidden 
  #     configure :servicegroup_member_ids, :serialized         # Hidden 
  #     configure :servicegroup_name, :text 
  #     configure :alias, :text 
  #     configure :notes, :text 
  #     configure :notes_url, :text 
  #     configure :action_url, :text   #   # Sections:
    list do
      field :servicegroup_name
      field :alias
      field :notes
      field :notes_url
      field :action_url
    end
  #   export do; end
  #   show do; end
    edit do
      field :servicegroup_name
      field :alias

      field :members # Service.all
      field :servicegroup_members # Servicegroup.all

      field :notes
      field :notes_url
      field :action_url
    end
  #   create do; end
  #   update do; end
  end

  config.model Timeperiod do
  #   # Found associations:
  #     configure :host_notification_contacts, :has_many_association 
  #     configure :service_notification_contacts, :has_many_association 
  #     configure :check_period_hosts, :has_many_association 
  #     configure :notification_period_hosts, :has_many_association 
  #     configure :host_dependencies, :has_many_association 
  #     configure :check_period_services, :has_many_association 
  #     configure :notification_period_services, :has_many_association 
  #     configure :service_dependencies, :has_many_association 
  #     configure :hostescalations, :has_many_association 
  #     configure :serviceescalations, :has_many_association   #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :timeperiod_name, :text 
  #     configure :alias, :text   #   # Sections:
    list do
      field :timeperiod_name
      field :alias
    end
  #   export do; end
  #   show do; end
    edit do
      field :timeperiod_name
      field :alias
    end
  #   create do; end
  #   update do; end
  end

  # config.model User do
  #   # Found associations:
  #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :name, :string 
  #     configure :email, :text 
  #     configure :password, :password         # Hidden 
  #     configure :password_confirmation, :password         # Hidden 
  #     configure :reset_password_token, :text         # Hidden 
  #     configure :reset_password_sent_at, :datetime 
  #     configure :remember_created_at, :datetime 
  #     configure :sign_in_count, :integer 
  #     configure :current_sign_in_at, :datetime 
  #     configure :last_sign_in_at, :datetime 
  #     configure :current_sign_in_ip, :text 
  #     configure :last_sign_in_ip, :text 
  #     configure :failed_attempts, :integer 
  #     configure :unlock_token, :text 
  #     configure :locked_at, :datetime 
  #     configure :authentication_token, :text   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
end


