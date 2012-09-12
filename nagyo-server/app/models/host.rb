class Host
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields

  # has_many :parents, :class_name => ??
  has_and_belongs_to_many :hosts  # aka parents

  has_and_belongs_to_many :contacts

  has_and_belongs_to_many :hostgroups,
    :class_name => "Hostgroup",
    :inverse_of => :members

  has_many :services

  has_many :service_dependencies,
    :class_name => "Servicedependency",
    :inverse_of => :host
  has_many :dependent_service_dependencies,
    :class_name => "Servicedependency",
    :inverse_of => :dependent_host

  has_and_belongs_to_many :contact_groups,
    :class_name => "Contactgroup",
    :inverse_of => :hosts

  belongs_to :check_command,
    :class_name => "Command"
  belongs_to :event_handler,
    :class_name => "Command"

  belongs_to :check_period,
    :class_name => "Timeperiod",
    :inverse_of => :check_period_hosts
  belongs_to :notification_period,
    :class_name => "Timeperiod",
    :inverse_of => :notification_period_hosts


  # required:
  field :host_name,             type: String
  field :alias,                 type: String
  field :address,               type: String
  field :max_check_attempts,    type: Integer, :default => 3
  #field :check_period,          type: String,  :default => "24x7"
  #
  #field :contacts,              type: Array
  field :notification_interval, type: Integer, :default => 5
  #field :notification_period,   type: String,  :default => "24x7"

  # optional:
  field :notes,                        type: String
  field :notes_url,                    type: String
  field :action_url,                   type: String
  field :display_name,                 type: String
  #field :parents,                      type: Array
  # field :hostgroups,            type: Array
  #
  #field :check_command,                type: String
  field :initial_state,                type: String
  field :check_interval,               type: Integer
  field :retry_interval,               type: Integer
  field :active_checks_enabled,        type: Integer, :default => 1
  field :passive_checks_enabled,       type: Integer, :default => 1
  field :obsess_over_host,             type: Integer
  field :check_freshness,              type: Integer
  field :freshness_threshold,          type: Integer
  #field :event_handler,                type: String
  field :event_handler_enabled,        type: Integer, :default => 1
  field :low_flap_threshold,           type: Integer
  field :high_flap_threshold,          type: Integer
  field :flap_detection_enabled,       type: Integer, :default => 1
  field :flap_detection_options,       type: String
  field :process_perf_data,            type: Integer, :default => 0
  field :retain_status_information,    type: Integer, :default => 1
  field :retain_nonstatus_information, type: Integer, :default => 1
  field :first_notification_delay,     type: Integer
  field :notification_options,         type: String,  :default => "d,u,r"
  field :notifications_enabled,        type: Integer, :default => 1
  field :stalking_options,             type: String
  #
  #field :contact_groups,               type: Array
  field :icon_image,                   type: String
  field :icon_image_alt,               type: String
  field :vrml_image,                   type: String
  field :statusmap_image,              type: String

  # FIXME: these throw a syntax error for unexpected integer (begin with 
  # integer)
  #field :2d_coords,            type: String
  #field :3d_coords,            type: String

  # validations
  before_validation :set_alias_and_address_to_host_name, :reject_blank_inputs

  # FIXME: it seems mongoid thinks empty array sets count as presence of value.
  validates_presence_of        :host_name, :alias, :address, :max_check_attempts, :check_period, :contacts
  validates_presence_of        :notification_interval, :notification_period

  # FIXME: for whatever reason validations against multiple fields is not working like they did in MM
  validates_uniqueness_of    :host_name, :scope => [:check_period, :contacts, :notification_period]


  # TODO: how will has_scope scopes work with associations instead of arrays?  
  # hopefully works better!
  # scopes
  scope :host_name,           proc {|host_name| where(:host_name => host_name) }
  scope :alias,               proc {|_alias| where(:alias => _alias) }
  scope :address,             proc {|address| where(:address => address) }
  #
  scope :check_period,        proc {|check_period| where(:check_period => check_period) }
  #
  scope :notification_period, proc {|notification_period| where(:notification_period => notification_period) }
  #
  scope :contacts,            proc {|contacts| where(:contacts => contacts) }
  #
  scope :parents,             proc {|parents| where(:parents => parents) }
  #
  scope :hostgroups,          proc {|hostgroups| where(:hostgroups => hostgroups) }
  #
  scope :check_command,       proc {|check_command| where(:check_command => check_command) }


  def initialize(*params)
    super(*params)
  end

  def to_s
    "#{host_name}"
  end

private

  def set_alias_and_address_to_host_name
    self.alias   = self.host_name if self.alias.blank?
    self.address = self.host_name if self.address.blank?
  end

  # this also sets to empty array if not set/nil
  def reject_blank_inputs
    self.contacts   = self.contacts.to_a.reject(&:blank?)
    self.parents    = self.parents.to_a.reject(&:blank?)
    self.hostgroups = self.hostgroups.to_a.reject(&:blank?)
  end
end
