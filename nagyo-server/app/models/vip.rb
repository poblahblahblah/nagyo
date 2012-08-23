class Vip
  include MongoMapper::Document

  scope :nodegroup,	proc {|nodegroup| where(:nodegroup => nodegroup) }
  scope :vip_name,	proc {|vip_name| where(:vip_name => vip_name) }
  scope :vip_dns,	proc {|vip_dns| where(:vip_dns => vip_dns) }
  scope :check_command,	proc {|check_command| where(:check_command => check_command) }
  scope :ecv_uri,	proc {|ecv_uri| where(:ecv_uri => ecv_uri) }
  scope :ecv_string,	proc {|ecv_string| where(:ecv_string => ecv_string) }
  scope :contacts,	proc {|contacts| where(:contacts => contacts) }

  validates_uniqueness_of :nodegroup, :scope => [:check_command, :contacts, :vip_dns, :vip_name]
  before_save             :reject_empty_inputs

  # required:
  key :nodegroup,			String,	:required => true
  key :vip_name,			String, :required => true
  key :vip_dns,				String, :required => true
  key :check_command,			String, :required => true, :default => "check_eh_cluster-http"
  key :node_alert_when_down,		String, :required => true, :default => 1
  key :percent_warn,			String,	:required => true
  key :percent_crit,			String,	:required => true
  key :ecv_uri,				String,	:required => true
  key :ecv_string,			String,	:required => true
  key :contacts,			Array,  :required => true

  # optional:
  key :node_check_command,		String
  key :node_check_command_arguments,	String
  key :notify_on_node_service,		Boolean, :default => "false"

  timestamps!

  def initialize(*params)
    super(*params)
  end

  private
  def reject_empty_inputs
    contacts.reject!{|i| i.nil? or i.empty?}
  end
end
