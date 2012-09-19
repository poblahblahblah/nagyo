# RailsAdmin config file. Generated on September 18, 2012 11:53
# See github.com/sferik/rails_admin for more informations

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

  # config.model Cluster do
  #   # Found associations:
  #     configure :contacts, :has_and_belongs_to_many_association 
  #     configure :check_command, :belongs_to_association 
  #     configure :node_check_command, :belongs_to_association 
  #     configure :hostgroup, :belongs_to_association   #   # Found columns:
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
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Command do
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
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Contact do
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
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Contactgroup do
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
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Hardwareprofile do
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
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Host do
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
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Hostdependency do
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
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Hostescalation do
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
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Hostgroup do
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
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Service do
  #   # Found associations:
  #     configure :host, :belongs_to_association 
  #     configure :hostgroup, :belongs_to_association 
  #     configure :contacts, :has_and_belongs_to_many_association 
  #     configure :check_command, :belongs_to_association 
  #     configure :event_handler, :belongs_to_association 
  #     configure :check_period, :belongs_to_association 
  #     configure :notification_period, :belongs_to_association 
  #     configure :service_dependencies, :has_many_association 
  #     configure :dependent_service_dependencies, :has_many_association   #   # Found columns:
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
  #     configure :name, :string 
  #     configure :check_command_arguments, :text 
  #     configure :max_check_attempts, :integer 
  #     configure :check_interval, :integer 
  #     configure :retry_interval, :integer 
  #     configure :notification_interval, :integer 
  #     configure :service_description, :text 
  #     configure :display_name, :text 
  #     configure :servicegroups, :text 
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
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Servicedependency do
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
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Serviceescalation do
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
  #     configure :hostgroup_name, :text 
  #     configure :service_description, :text   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Servicegroup do
  #   # Found associations:
  #   # Found columns:
  #     configure :_type, :text         # Hidden 
  #     configure :_id, :bson_object_id 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :servicegroup_name, :text 
  #     configure :alias, :text 
  #     configure :members, :serialized 
  #     configure :servicegroup_members, :serialized 
  #     configure :notes, :text 
  #     configure :notes_url, :text 
  #     configure :action_url, :text   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Timeperiod do
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
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
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
