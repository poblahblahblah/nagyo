class Contact
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields

  #?
  has_and_belongs_to_many :clusters

  belongs_to :host_notification_period, :class_name => "Timeperiod"
  has_and_belongs_to_many :host_notification_commands, :class_name => "Command"

  belongs_to :service_notification_period, :class_name => "Timeperiod"
  has_and_belongs_to_many :service_notification_commands, :class_name => "Command"

  has_and_belongs_to_many :contact_groups, :class_name => "Contactgroup"

  has_and_belongs_to_many :hardwareprofiles
  has_and_belongs_to_many :hosts
  has_and_belongs_to_many :services
  has_and_belongs_to_many :vips


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
  # FIXME: why these? shouldn't a contact be able to start empty and build? why 
  # do we need all these other things to even build a contact?
  validates_presence_of   :host_notification_period, :service_notification_period, :host_notification_options
  validates_presence_of   :service_notification_options, :host_notification_commands, :service_notification_commands

  validates_numericality_of :host_notifications_enabled

  before_validation       :set_alias_to_contact_name
  before_validation       :reject_blank_inputs


  def initialize(*params)
    super(*params)
  end

private

  def set_alias_to_contact_name
    self.alias = self.contact_name if self.alias.blank?
  end

  def reject_blank_inputs
    contact_groups = contact_groups.to_a.reject(&:blank?)
  end

end
