class Vip
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields

  scope :nodegroup,     proc {|nodegroup| where(:nodegroup => nodegroup) }
  scope :vip_name,      proc {|vip_name| where(:vip_name => vip_name) }
  scope :vip_dns,       proc {|vip_dns| where(:vip_dns => vip_dns) }
  scope :check_command, proc {|check_command| where(:check_command => check_command) }
  scope :ecv_uri,       proc {|ecv_uri| where(:ecv_uri => ecv_uri) }
  scope :ecv_string,    proc {|ecv_string| where(:ecv_string => ecv_string) }
  scope :contacts,      proc {|contacts| where(:contacts => contacts) }

  # validations
  validates_presence_of		:nodegroup, :vip_name, :vip_dns, :check_command, :node_alert_when_down
  validates_presence_of		:percent_warn, :percent_crit, :ecv_uri, :ecv_string, :contacts
  validates_uniqueness_of	:nodegroup, :scope => [:check_command, :contacts, :vip_dns, :vip_name]
  before_validation		:reject_blank_inputs

  # required:
  field :nodegroup,            type: String
  field :vip_name,             type: String
  field :vip_dns,              type: String
  # TODO: has_one :check_command, class: "Command", ...
  field :check_command,        type: String, default: "check_eh_cluster-http"
  field :node_alert_when_down, type: String, default: 1
  field :percent_warn,         type: String
  field :percent_crit,         type: String
  field :ecv_uri,              type: String
  field :ecv_string,           type: String
  field :contacts,             type: Array

  # optional:
  field :node_check_command,           type: String
  field :node_check_command_arguments, type: String
  field :notify_on_node_service,       type: Boolean, default: false


  def initialize(*params)
    super(*params)
  end

private

  def reject_blank_inputs
    contacts = contacts.to_a.reject(&:blank?)
  end

end
