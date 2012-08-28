class Contact
  include MongoMapper::Document

  scope :contact_name,			proc {|contact_name| where(:contact_name => contact_name) }
  scope :email,				proc {|email| where(:email => email) }
  scope :host_notification_period,	proc {|host_notification_period| where(:host_notification_period => host_notification_period) }
  scope :service_notification_period,	proc {|service_notification_period| where(:service_notification_period => service_notification_period) }

  before_validation :set_alias_to_contact_name
  before_save       :reject_empty_inputs

  # required:
  key :contact_name,			String,		:required => true, :unique => true
  key :email,				String,		:required => true
  key :host_notifications_enabled,	Integer,	:required => true, :default => 1
  key :service_notifications_enabled,	Integer,	:required => true, :default => 1
  key :host_notification_period,	String,		:required => true, :default => "24x7"
  key :service_notification_period,	String,		:required => true, :default => "24x7"
  key :host_notification_options,	String,		:required => true, :default => "d,u,r"
  key :service_notification_options,	String,		:required => true, :default => "w,u,c,r"
  key :host_notification_commands,	String,		:required => true
  key :service_notification_commands,	String,		:required => true

  # optional:
  key :alias,                        String
  key :contact_groups,               Array
  key :pager,                        String
  key :addressx,                     String
  key :can_submit_commands,          Integer
  key :retain_status_information,    Integer
  key :retain_nonstatus_information, Integer

  timestamps!

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
