class Hostescalation
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields
  include Extensions::DereferencedJson
  include Extensions::SerializedNagiosOptions

  # associations
  belongs_to :host
  belongs_to :hostgroup

  has_and_belongs_to_many :contacts
  has_and_belongs_to_many :contact_groups,
    :class_name => "Contactgroup",
    :inverse_of => :hostescalations

  belongs_to :escalation_period,
    :class_name => "Timeperiod",
    :inverse_of => :hostescalations

  # fields
  field :first_notification,      type: Integer
  field :last_notification,       type: Integer
  field :notification_interval,   type: Integer

  field :escalation_options,      type: String

  # these are copied from associations
  field :host_name,           type: String
  field :hostgroup_name,      type: String

  before_save :copy_name_fields

  serialize_nagios_options :escalation_options, :valid => %w{d u r}

  # validations
  validates_presence_of :host, :contacts, :contact_groups
  validates_presence_of :first_notification, :last_notification, :notification_interval


protected

  def copy_name_fields
    self.host_name      = self.host.host_name rescue nil
    self.hostgroup_name = self.hostgroup.hostgroup_name rescue nil
  end

end

