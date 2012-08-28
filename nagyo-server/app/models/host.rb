class Host
  include MongoMapper::Document

  scope :host_name,		proc {|host_name| where(:host_name => host_name) }
  scope :alias,			proc {|_alias| where(:alias => _alias) }
  scope :address,		proc {|address| where(:address => address) }
  scope :check_period,		proc {|check_period| where(:check_period => check_period) }
  scope :notification_period,	proc {|notification_period| where(:notification_period => notification_period) }
  scope :contacts,		proc {|contacts| where(:contacts => contacts) }
  scope :parents,		proc {|parents| where(:parents => parents) }
  scope :hostgroups,		proc {|hostgroups| where(:hostgroups => hostgroups) }
  scope :check_command,		proc {|check_command| where(:check_command => check_command) }

  before_validation :set_alias_and_address_to_host_name
  before_save       :reject_empty_inputs

  # need to figure out a good combo of uniqueness
  validates_uniqueness_of :host_name, :scope => [:check_period, :contacts, :notification_period]

  # required:
  key :host_name,             String,  :required => true
  key :alias,                 String,  :required => true
  key :address,               String,  :required => true
  key :max_check_attempts,    Integer, :required => true, :default => 3
  key :check_period,          String,  :required => true, :default => "24x7"
  key :contacts,              Array,   :required => true
  key :notification_interval, Integer, :required => true, :default => 5
  key :notification_period,   String,  :required => true, :default => "24x7"

  # optional:
  key :notes,                        String
  key :notes_url,                    String
  key :action_url,                   String
  key :display_name,                 String
  key :parents,                      Array
  key :hostgroups,                   Array
  key :check_command,                String
  key :initial_state,                String
  key :check_interval,               Integer
  key :retry_interval,               Integer
  key :active_checks_enabled,        Integer, :default => 1
  key :passive_checks_enabled,       Integer, :default => 1
  key :obsess_over_host,             Integer
  key :check_freshness,              Integer
  key :freshness_threshold,          Integer
  key :event_handler,                String
  key :event_handler_enabled,        Integer, :default => 1
  key :low_flap_threshold,           Integer
  key :high_flap_threshold,          Integer
  key :flap_detection_enabled,       Integer, :default => 1
  key :flap_detection_options,       String
  key :process_perf_data,            Integer, :default => 0
  key :retain_status_information,    Integer, :default => 1
  key :retain_nonstatus_information, Integer, :default => 1
  key :first_notification_delay,     Integer
  key :notification_options,         String,  :default => "d,u,r"
  key :notifications_enabled,        Integer, :default => 1
  key :stalking_options,             String
  key :contact_groups,               Array
  key :icon_image,                   String
  key :icon_image_alt,               String
  key :vrml_image,                   String
  key :statusmap_image,              String

  # FIXME: these throw a syntax error for unexpected integer
  #key :2d_coords,                    String
  #key :3d_coords,                    String

  timestamps!

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
