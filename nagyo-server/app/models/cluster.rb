# TODO: merge Vip model into Cluster
#
class Cluster
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields
  include Extensions::DereferencedJson

  # habtm?
  has_and_belongs_to_many :contacts

  belongs_to :check_command,
    :class_name => "Command",
    :inverse_of => :check_command_clusters
  belongs_to :node_check_command,
    :class_name => "Command",
    :inverse_of => :node_check_command_clusters

  belongs_to :hostgroup

  # required:

  ## NOTE: these fields were merged over from Vip model
  # NOTE: having trouble using :name as a field - seems to conflict with Class 
  # name when has_scopes is used
  field :vip_name,             type: String
  field :vip_dns,              type: String
  field :node_alert_when_down, type: String, default: 1
  field :percent_warn,         type: String
  field :percent_crit,         type: String
  field :ecv_uri,              type: String
  field :ecv_string,           type: String

  field :check_command_arguments, type: String

  # optional:
  field :node_check_command_arguments,    type: String
  # Integer or Boolean??
  #field :notify_on_node_service,          type: Boolean, default: false
  field :notify_on_node_service,          type: Integer, default: 0



  validates_presence_of :hostgroup, :check_command, :check_command_arguments, :contacts
  # validations
  validates_presence_of :vip_name, :vip_dns, :node_alert_when_down
  validates_presence_of :percent_warn, :percent_crit, :ecv_uri, :ecv_string

  validates_uniqueness_of :vip_name

  # FIXME: cannot validate uniqueness when nil or one of others is array ? or 
  #validates_uniqueness_of  :hostgroup, :scope => [:check_command, :contacts]
  #validates_uniqueness_of       :hostgroup, :scope => [:check_command, 
  #:contacts, :vip_dns, :vip_name]


  # scopes
  scope :hostgroup,     proc {|hostgroup| where(:hostgroup => hostgroup) }
  scope :check_command, proc {|check_command| where(:check_command => check_command) }
  scope :contacts,      proc {|contacts| where(:contacts => contacts) }
  scope :vip_name,      proc {|vip_name| where(:vip_name => vip_name) }
  scope :vip_dns,       proc {|vip_dns| where(:vip_dns => vip_dns) }
  scope :ecv_uri,       proc {|ecv_uri| where(:ecv_uri => ecv_uri) }
  scope :ecv_string,    proc {|ecv_string| where(:ecv_string => ecv_string) }


  def initialize(*params)
    super(*params)
  end

  def to_s
    "#{vip_name}"
  end

end
