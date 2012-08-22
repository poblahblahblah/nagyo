class Service
  include MongoMapper::Document

  scope :nodegroup,		proc {|nodegroup| where(:_nodegroup => nodegroup) } 
  scope :check_command,		proc {|check_command| where(:check_command => check_command) } 
  scope :check_period,		proc {|check_period| where(:check_period => check_period) } 
  scope :notification_period,	proc {|notification_period| where(:notification_period => notification_period) } 
  scope :contacts,		proc {|contacts| where(:contacts => contacts) } 
  scope :servicegroups,		proc {|servicegroups| where(:servicegroups => servicegroups) } 

  # I have the key "name" not visible in the view - I would rather put this together 
  # before validation so we can have a "standard" way of naming all of our services.
  before_validation :set_name_from_input_values

  validates_uniqueness_of :_nodegroup, :scope => [:check_command, :contacts, :notification_period]

  # required:
  # note that we use "_nodegroup" instead of hostgroup_name - this is functionally
  # the same thing to us.
  key :_nodegroup,			String,		:required => true
  key :name,				String,		:required => true
  key :check_command,			String,		:required => true
  key :check_command_arguments,		String,		:required => true
  key :max_check_attempts,		Integer,	:required => true, :default => 3
  key :check_interval,			Integer,	:required => true, :default => 3
  key :retry_interval,			Integer,	:required => true, :default => 3
  key :check_period,			String,		:required => true, :default => "24x7"
  key :notification_interval,		Integer,	:required => true, :default => 60
  key :notification_period,		String,		:required => true, :default => "24x7"
  key :contacts,			String,		:required => true

  # optional:
  key :service_description,		String
  key :display_name,			String
  key :servicegroups,			String
  key :is_volatile,			Integer,	:default => 0
  key :initial_state,			String
  key :active_checks_enabled,		Integer,	:default => 1
  key :passive_checks_enabled,		Integer,	:default => 1
  key :obsess_over_service,		Integer,	:default => 0
  key :check_freshness,			Integer,	:default => 0
  key :freshness_threshold,		Integer,	:default => 1200
  key :event_handler,			String
  key :event_handler_enabled,		Integer,	:default => 0
  key :low_flap_threshold,		Integer
  key :high_flap_threshold,		Integer
  key :flap_detection_enabled,		Integer,	:default => 0
  key :flap_detection_options,		String
  key :process_perf_data,		Integer,	:default => 0
  key :retain_status_information,	Integer,	:default => 1
  key :retain_nonstatus_information,	Integer,	:default => 1
  key :first_notification_delay,	Integer
  key :notification_options,		String
  key :notifications_enabled,		Integer
  key :stalking_options,		String
  key :register,			Integer,	:default => 1
  key :notes,				String
  key :notes_url,			String
  key :action_url,			String

  timestamps!

  def initialize(*params)
    super(*params)
  end

  private
  def set_name_from_input_values
    self.name = [self._nodegroup, self.check_command, self.contacts, self.notification_period].join('-')
  end
end
