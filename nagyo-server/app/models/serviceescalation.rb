class Serviceescalation
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields
  include Extensions::DereferencedJson
  include Extensions::SerializedNagiosOptions

  # TODO: complete this model ...
  
  # associations
  belongs_to :host
  belongs_to :hostgroup
  belongs_to :service

  has_and_belongs_to_many :contacts
  has_and_belongs_to_many :contact_groups,
    :class_name => "Contactgroup",
    :inverse_of => :serviceescalations

  belongs_to :escalation_period,
    :class_name => "Timeperiod",
    :inverse_of => :serviceescalations


  # fields
  field :first_notification,      type: Integer
  field :last_notification,       type: Integer
  field :notification_interval,   type: Integer

  field :escalation_options,      type: String

  # these are copied from associations
  field :host_name,           type: String
  field :hostgroup_name,      type: String
  field :service_description, type: String

  before_save :copy_name_fields

  serialize_nagios_options :escalation_options, :valid => %w{w u c r}

  # validations
  validates_presence_of :host, :service, :contacts, :contact_groups
  validates_presence_of :first_notification, :last_notification, :notification_interval



protected

  def copy_name_fields
    self.host_name           = self.host.host_name rescue nil
    self.hostgroup_name      = self.hostgroup.hostgroup_name rescue nil
    self.service_description = self.service.name rescue nil
  end
end

