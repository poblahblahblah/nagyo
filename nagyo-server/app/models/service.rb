class Service
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields

  has_and_belongs_to_many :contacts

  belongs_to :check_command,
    :class_name => "Command",
    :inverse_of => :check_command_services
  belongs_to :event_handler,
    :class_name => "Command",
    :inverse_of => :event_handler_services

  belongs_to :check_period,
    :class_name => "Timeperiod",
    :inverse_of => :check_period_services
  belongs_to :notification_period,
    :class_name => "Timeperiod",
    :inverse_of => :notification_period_services

  belongs_to :hostgroup  # TODO: hostgroup_name
  belongs_to :host  # TODO: host_name

  has_many :service_dependencies,
    :class_name => "Servicedependency",
    :inverse_of => :service
  has_many :dependent_service_dependencies,
    :class_name => "Servicedependency",
    :inverse_of => :dependent_service

  # required:
  # note that we use "nodegroup" instead of hostgroup_name - this is functionally
  # the same thing to us.
  # FIXME: TODO: make nodegroup a proper Hostgroup association
  field :nodegroup,                     type: String

  field :name,                          type: String
  field :check_command,                 type: String
  field :check_command_arguments,       type: String
  field :max_check_attempts,            type: Integer,  :default => 3
  field :check_interval,                type: Integer,  :default => 3
  field :retry_interval,                type: Integer,  :default => 3
  field :check_period,                  type: String,   :default => "24x7"
  field :notification_interval,         type: Integer,  :default => 60
  field :notification_period,           type: String,   :default => "24x7"
  field :contacts,                      type: Array

  # optional:
  # these two are hidden in the view:
  field :host_name,                     type: Array
  field :hostgroup_name,                type: Array

  field :service_description,           type: String
  field :display_name,                  type: String
  field :servicegroups,                 type: String
  field :is_volatile,                   type: Integer,  :default => 0
  field :initial_state,                 type: String
  field :active_checks_enabled,         type: Integer,  :default => 1
  field :passive_checks_enabled,        type: Integer,  :default => 1
  field :obsess_over_service,           type: Integer,  :default => 0
  field :check_freshness,               type: Integer,  :default => 0
  field :freshness_threshold,           type: Integer,  :default => 1200
  field :event_handler,                 type: String
  field :event_handler_enabled,         type: Integer,  :default => 0
  field :low_flap_threshold,            type: Integer
  field :high_flap_threshold,           type: Integer
  field :flap_detection_enabled,        type: Integer,  :default => 0
  field :flap_detection_options,        type: String
  field :process_perf_data,             type: Integer,  :default => 0
  field :retain_status_information,     type: Integer,  :default => 1
  field :retain_nonstatus_information,  type: Integer,  :default => 1
  field :first_notification_delay,      type: Integer
  field :notification_options,          type: String
  field :notifications_enabled,         type: Integer
  field :stalking_options,              type: String
  field :register,                      type: Integer,  :default => 1
  field :notes,                         type: String
  field :notes_url,                     type: String
  field :action_url,                    type: String
  field :icon_image,                    type: String
  field :icon_image_alt,                type: String

  # scopes
  scope :nodegroup,             proc {|nodegroup| where(:nodegroup => nodegroup) } 
  scope :check_command,         proc {|check_command| where(:check_command => check_command) } 
  scope :check_period,          proc {|check_period| where(:check_period => check_period) } 
  scope :notification_period,   proc {|notification_period| where(:notification_period => notification_period) } 
  scope :contacts,              proc {|contacts| where(:contacts => contacts) } 
  scope :servicegroups,         proc {|servicegroups| where(:servicegroups => servicegroups) } 

  # validations
  # I have the field "name" not visible in the view - I would rather put this together 
  # before validation so we can have a "standard" way of naming all of our services.
  before_validation             :set_name_from_input_values
  before_validation             :reject_blank_inputs

  validates_presence_of         :nodegroup, :name, :check_command, :check_command_arguments, :max_check_attempts
  validates_presence_of         :check_interval, :check_period, :notification_interval, :notification_period
  validates_presence_of         :contacts
  validates_uniqueness_of       :nodegroup, :scope => [:check_command, :contacts, :notification_period]


  def initialize(*params)
    super(*params)
  end

  def to_s
    "#{name}"
  end

private

  def set_name_from_input_values
    self.name = [self.nodegroup, self.check_command, self.contacts, self.notification_period].join('-')
  end

  def reject_blank_inputs
    contacts = contacts.to_a.reject(&:blank?)
    host_name = host_name.to_a.reject(&:blank?)
    hostgroup_name = hostgroup_name.to_a.reject(&:blank?)
  end
end
