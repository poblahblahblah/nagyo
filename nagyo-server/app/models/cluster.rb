class Cluster
  include Mongoid::Document
  include Mongoid::Timestamps

  scope :nodegroup,     proc {|nodegroup| where(:nodegroup => nodegroup) }
  scope :check_command, proc {|check_command| where(:check_command => check_command) }
  scope :contacts,      proc {|contacts| where(:contacts => contacts) }

  validates_uniqueness_of :nodegroup, :scope => [:check_command, :contacts]
  before_save             :reject_empty_inputs

  # required:
  field :nodegroup,               type: String #:required => true
  field :check_command,           type: String, default: "check_eh_cluster-http" #:required => true
  field :check_command_arguments, type: String #:required => true
  field :contacts,                type: Array  #:required => true

  # optional:
  field :node_check_command,              type: String
  field :node_check_command_arguments,    type: String
  field :notify_on_node_service,          type: Boolean, default: false

  # ??
  #timestamps!

  def initialize(*params)
    super(*params)
  end

  private
  def reject_empty_inputs
    contacts.reject!{|i| i.nil? or i.empty?}
  end
end
