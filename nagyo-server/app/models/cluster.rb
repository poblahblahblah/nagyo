class Cluster
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields

  # habtm?
  has_and_belongs_to_many :contacts
  belongs_to :check_command,      :class_name => "Command"
  belongs_to :node_check_command, :class_name => "Command"

  # required:
  field :nodegroup,               type: String
  #field :check_command, type: String, default: "check_eh_cluster-http"
  field :check_command_arguments, type: String
  #field :contacts,                type: Array

  # optional:
  #field :node_check_command,              type: String
  field :node_check_command_arguments,    type: String
  field :notify_on_node_service,          type: Boolean, default: false

  # scopes
  scope :nodegroup,     proc {|nodegroup| where(:nodegroup => nodegroup) }
  scope :check_command, proc {|check_command| where(:check_command => check_command) }
  scope :contacts,      proc {|contacts| where(:contacts => contacts) }

  validates_presence_of    :nodegroup, :check_command, :check_command_arguments, :contacts
  validates_uniqueness_of  :nodegroup, :scope => [:check_command, :contacts]
  before_validation        :reject_blank_inputs


  def initialize(*params)
    super(*params)
  end

private

  def reject_blank_inputs
    contacts = contacts.to_a.reject{|i| i.blank? }
  end

end
