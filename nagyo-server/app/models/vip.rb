class Vip
  include Mongoid::Document
  include Mongoid::Timestamps

  scope :nodegroup,     proc {|nodegroup| where(:nodegroup => nodegroup) }
  scope :vip_name,      proc {|vip_name| where(:vip_name => vip_name) }
  scope :vip_dns,       proc {|vip_dns| where(:vip_dns => vip_dns) }
  scope :check_command, proc {|check_command| where(:check_command => check_command) }
  scope :ecv_uri,       proc {|ecv_uri| where(:ecv_uri => ecv_uri) }
  scope :ecv_string,    proc {|ecv_string| where(:ecv_string => ecv_string) }
  scope :contacts,      proc {|contacts| where(:contacts => contacts) }

  validates_uniqueness_of :nodegroup, :scope => [:check_command, :contacts, :vip_dns, :vip_name]
  before_save             :reject_empty_inputs

  # required:
  field :nodegroup,            type: String  #:required => true
  field :vip_name,             type: String  #:required => true
  field :vip_dns,              type: String  #:required => true
  # TODO: has_one :check_command, class: "Command", ...
  field :check_command,        type: String  #:required => true, :default => "check_eh_cluster-http"
  field :node_alert_when_down, type: String  #:required => true, :default => 1
  field :percent_warn,         type: String  #:required => true
  field :percent_crit,         type: String  #:required => true
  field :ecv_uri,              type: String  #:required => true
  field :ecv_string,           type: String  #:required => true
  field :contacts,             type: Array  #  :required => true

  # optional:
  field :node_check_command,           type: String
  field :node_check_command_arguments, type: String
  field :notify_on_node_service,       type: Boolean, default: false

  #timestamps!

  def initialize(*params)
    super(*params)
  end

  private
  def reject_empty_inputs
    contacts.reject!{|i| i.nil? or i.empty?}
  end
end
