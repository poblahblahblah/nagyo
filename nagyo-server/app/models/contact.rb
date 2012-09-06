class Contact
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields

  # scopes
  scope :contact_name,			proc {|contact_name| where(:contact_name => contact_name) }
  scope :email,				proc {|email| where(:email => email) }
  scope :host_notification_period,	proc {|host_notification_period| where(:host_notification_period => host_notification_period) }
  scope :service_notification_period,	proc {|service_notification_period| where(:service_notification_period => service_notification_period) }

  # validations
  validates_uniqueness_of :contact_name
  validates_presence_of   :contact_name, :email, :host_notifications_enabled, :service_notifications_enabled
  validates_presence_of   :host_notification_period, :service_notification_period, :host_notification_options
  validates_presence_of   :service_notification_options, :host_notification_commands, :service_notification_commands
  before_validation       :set_alias_to_contact_name
  before_save             :reject_empty_inputs

  has_many :timeperiods

  # required:
  field :contact_name,			type: String
  field :email,				type: String
  field :host_notifications_enabled,	type: Integer
  field :service_notifications_enabled,	type: Integer,	default:  1
  field :host_notification_period,	type: String,	default:  "24x7"
  field :service_notification_period,	type: String,	default:  "24x7"
  field :host_notification_options,	type: String,	default:  "d,u,r"
  field :service_notification_options,	type: String,	default:  "w,u,c,r"
  field :host_notification_commands,	type: String
  field :service_notification_commands,	type: String

  # optional:
  field :alias,                        type: String
  field :contact_groups,               type: Array
  field :pager,                        type: String
  field :addressx,                     type: String
  field :can_submit_commands,          type: Integer
  field :retain_status_information,    type: Integer
  field :retain_nonstatus_information, type: Integer

  def initialize(*params)
    super(*params)
  end

  private
  def set_alias_to_contact_name
    self.alias = self.contact_name if self.alias.empty?
  end

  def reject_empty_inputs
    contact_groups.reject!{|i| i.nil? or i.empty?}
  end

end
