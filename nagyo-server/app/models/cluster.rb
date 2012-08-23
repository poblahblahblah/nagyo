class Cluster
  include MongoMapper::Document

  scope :nodegroup,	proc {|nodegroup| where(:nodegroup => nodegroup) }
  scope :check_command,	proc {|check_command| where(:check_command => check_command) }
  scope :contacts,	proc {|contacts| where(:contacts => contacts) }

  validates_uniqueness_of :nodegroup, :scope => [:check_command, :contacts]
  before_save             :reject_empty_inputs

  # required:
  key :nodegroup,		String,	:required => true
  key :check_command,		String, :required => true, :default => "check_eh_cluster-http"
  key :check_command_arguments,	String, :required => true
  key :contacts,		Array,  :required => true

  # optional:
  key :node_check_command,              String
  key :node_check_command_arguments,    String
  key :notify_on_node_service,          Boolean, :default => "false"

  timestamps!

  def initialize(*params)
    super(*params)
  end

  private
  def reject_empty_inputs
    contacts.reject!{|i| i.nil? or i.empty?}
  end
end
