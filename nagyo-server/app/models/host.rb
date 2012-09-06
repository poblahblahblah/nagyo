class Host
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields

  # scopes
  scope :host_name,		proc {|host_name| where(:host_name => host_name) }
  scope :alias,			proc {|_alias| where(:alias => _alias) }
  scope :address,		proc {|address| where(:address => address) }
  scope :check_period,		proc {|check_period| where(:check_period => check_period) }
  scope :notification_period,	proc {|notification_period| where(:notification_period => notification_period) }
  scope :contacts,		proc {|contacts| where(:contacts => contacts) }
  scope :parents,		proc {|parents| where(:parents => parents) }
  scope :hostgroups,		proc {|hostgroups| where(:hostgroups => hostgroups) }
  scope :check_command,		proc {|check_command| where(:check_command => check_command) }

  # validations
  before_validation		:set_alias_and_address_to_host_name
  before_save			:reject_empty_inputs

  # FIXME: it seems mongoid thinks empty array sets count as presence of value.
  validates_presence_of		:host_name, :alias, :address, :max_check_attempts, :check_period, :contacts
  validates_presence_of		:notification_interval, :notification_period

  # FIXME: for whatever reason validations against multiple fields is not working like they did in MM
  validates_uniqueness_of	:host_name, :scope => [:check_period, :contacts, :notification_period]

  # required:
  field :host_name,             type: String
  field :alias,                 type: String
  field :address,               type: String
  field :max_check_attempts,    type: Integer,	:default => 3
  field :check_period,          type: String,	:default => "24x7"
  field :contacts,              type: Array
  field :notification_interval, type: Integer,	:default => 5
  field :notification_period,   type: String,	:default => "24x7"

  # optional:
  field :notes,				type: String
  field :notes_url,			type: String
  field :action_url,			type: String
  field :display_name,			type: String
  field :parents,			type: Array
  field :hostgroups,			type: Array
  field :check_command,			type: String
  field :initial_state,			type: String
  field :check_interval,		type: Integer
  field :retry_interval,		type: Integer
  field :active_checks_enabled,		type: Integer, :default => 1
  field :passive_checks_enabled,	type: Integer, :default => 1
  field :obsess_over_host,		type: Integer
  field :check_freshness,		type: Integer
  field :freshness_threshold,		type: Integer
  field :event_handler,			type: String
  field :event_handler_enabled,		type: Integer, :default => 1
  field :low_flap_threshold,		type: Integer
  field :high_flap_threshold,		type: Integer
  field :flap_detection_enabled,	type: Integer, :default => 1
  field :flap_detection_options,	type: String
  field :process_perf_data,		type: Integer, :default => 0
  field :retain_status_information,	type: Integer, :default => 1
  field :retain_nonstatus_information,	type: Integer, :default => 1
  field :first_notification_delay,	type: Integer
  field :notification_options,		type: String,  :default => "d,u,r"
  field :notifications_enabled,		type: Integer, :default => 1
  field :stalking_options,		type: String
  field :contact_groups,		type: Array
  field :icon_image,			type: String
  field :icon_image_alt,		type: String
  field :vrml_image,			type: String
  field :statusmap_image,		type: String

  # FIXME: these throw a syntax error for unexpected integer
  #field :2d_coords,			type: String
  #field :3d_coords,			type: String

  def initialize(*params)
    super(*params)
  end

  private
  def set_alias_and_address_to_host_name
    self.alias   = self.host_name if self.alias.empty?
    self.address = self.host_name if self.address.empty?
  end

  def reject_empty_inputs
    contacts.reject!{|i| i.nil? or i.empty?}
    parents.reject!{|i| i.nil? or i.empty?}
    hostgroups.reject!{|i| i.nil? or i.empty?}
  end
end
