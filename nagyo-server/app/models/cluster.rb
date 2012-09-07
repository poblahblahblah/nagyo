class Cluster
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields

  # scopes
  scope :nodegroup,     proc {|nodegroup| where(:nodegroup => nodegroup) }
  scope :check_command, proc {|check_command| where(:check_command => check_command) }
  scope :contacts,      proc {|contacts| where(:contacts => contacts) }

  validates_presence_of    :nodegroup, :check_command, :check_command_arguments, :contacts
  validates_uniqueness_of  :nodegroup, :scope => [:check_command, :contacts]
  before_save              :reject_empty_inputs

  # required:
  field :nodegroup,               type: String
  field :check_command,           type: String, default: "check_eh_cluster-http"
  field :check_command_arguments, type: String
  field :contacts,                type: Array

  # optional:
  field :node_check_command,              type: String
  field :node_check_command_arguments,    type: String
  field :notify_on_node_service,          type: Boolean, default: false


  def initialize(*params)
    super(*params)
  end

  private
  def reject_empty_inputs
    contacts.reject!{|i| i.nil? or i.empty?}
  end
end
