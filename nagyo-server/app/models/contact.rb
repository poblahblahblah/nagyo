class Contact
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields
  include Extensions::DereferencedJson

  has_and_belongs_to_many :clusters
  has_and_belongs_to_many :hardwareprofiles
  has_and_belongs_to_many :hosts
  has_and_belongs_to_many :hostescalations
  has_and_belongs_to_many :services
  has_and_belongs_to_many :serviceescalations

  has_and_belongs_to_many :host_notification_commands,
    :class_name => "Command",
    :inverse_of => :host_notification_contacts
  has_and_belongs_to_many :service_notification_commands,
    :class_name => "Command",
    :inverse_of => :service_notification_contacts

  has_and_belongs_to_many :contact_groups,
    :class_name => "Contactgroup",
    :inverse_of => :members

  belongs_to :host_notification_period,
    :class_name => "Timeperiod",
    :inverse_of => :host_notification_contacts
  belongs_to :service_notification_period,
    :class_name => "Timeperiod",
    :inverse_of => :service_notification_contacts


  # required:
  field :contact_name,                   type: String
  field :email,                          type: String
  # is this really a boolean? integer?
  field :host_notifications_enabled,     type: Integer,  default:  1
  field :service_notifications_enabled,  type: Integer,  default:  1
  # TODO: convert defaults into before_validation callbacks?
  #field :host_notification_period,       type: String,   default:  "24x7"
  #field :service_notification_period,    type: String,   default:  "24x7"
  field :host_notification_options,      type: String,   default:  "d,u,r"
  field :service_notification_options,   type: String,   default:  "w,u,c,r"
  #field :host_notification_commands,     type: Array
  #field :service_notification_commands,  type: Array

  # optional:
  field :alias,                          type: String
  #field :contact_groups,                 type: Array
  field :pager,                          type: String
  field :addressx,                       type: String
  field :can_submit_commands,            type: Integer
  field :retain_status_information,      type: Integer
  field :retain_nonstatus_information,   type: Integer

  # scopes
  [:contact_name, :email, :host_notification_period, :service_notification_period].each do |k|
    scope k, proc {|arg| where(k => arg) }
  end

  # validations
  # FIXME: some of the validations appear to be not working as expected.
  # FIXME: see the host model for an actual explanation.
  validates_uniqueness_of :contact_name
  validates_presence_of   :contact_name, :email, :host_notifications_enabled, :service_notifications_enabled
  # TODO: should we use these to validate associations or doesn't mongoid 
  # validate automatically?
  validates_presence_of   :host_notification_period, :host_notification_commands, :host_notification_options
  validates_presence_of   :service_notification_period, :service_notification_commands, :service_notification_options

  # TODO: should these be boolean flags? need to convert to 1/0 for nagios 
  validates_numericality_of :host_notifications_enabled, :service_notifications_enabled

  before_validation       :set_alias_to_contact_name

  def initialize(*params)
    super(*params)
  end

  def to_s
    "#{contact_name}"
  end

private

  def set_alias_to_contact_name
    self.alias = self.contact_name if self.alias.blank?
  end

end
