class Cluster
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields

  # habtm?
  has_and_belongs_to_many :contacts

  belongs_to :check_command,
    :class_name => "Command",
    :inverse_of => :check_command_clusters
  belongs_to :node_check_command,
    :class_name => "Command",
    :inverse_of => :node_check_command_clusters

  # required:
  #
  # NOTE: "the term nodegroup is from nventory, but it basically means the same 
  # thing as hostgroup to nagios. we pull nodegroup info from nventory, so no 
  # association is needed"
  #
  field :nodegroup,               type: String
  # FIXME: TODO: use default type for association too  ...
  #field :check_command, type: String, default: "check_eh_cluster-http"
  field :check_command_arguments, type: String
  #field :contacts,                type: Array

  # optional:
  #field :node_check_command,              type: String
  field :node_check_command_arguments,    type: String
  field :notify_on_node_service,          type: Boolean, default: false

  validates_presence_of    :nodegroup, :check_command, :check_command_arguments, :contacts
  validates_uniqueness_of  :nodegroup, :scope => [:check_command, :contacts]
  before_validation        :reject_blank_inputs


  # scopes
  scope :nodegroup,     proc {|nodegroup| where(:nodegroup => nodegroup) }
  scope :check_command, proc {|check_command| where(:check_command => check_command) }
  scope :contacts,      proc {|contacts| where(:contacts => contacts) }


  def initialize(*params)
    super(*params)
  end

  # NOTE: this will not be globally unique ... but should we expose anyway?
  #def to_s
  #  "#{nodegroup}"
  #end

private

  def reject_blank_inputs
    contacts = contacts.to_a.reject{|i| i.blank? }
  end

end
