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


  def initialize(*params)
    super(*params)
  end

  def to_s
    "#{vip_name}"
  end

end
