class Hostdependency
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :dependency_period, :class_name => "Timeperiod"

  # required:
  field :dependent_host_name, type: String
  field :host_name,           type: String

  # optional:
  field :members,                       type: Array
  field :dependent_hostgroup_name,      type: String
  field :hostgroup_name,                type: String
  field :inherits_parent,               type: Integer
  field :execution_failure_criteria,    type: String
  field :notification_failure_criteria, type: String
  #field :dependency_period, type: String, default: "workhours"

  #timestamps!

  scope :host_name,                     proc {|host_name| where(:host_name => host_name)}
  scope :dependent_host_name,           proc {|dependent_host_name| where(:dependent_host_name => dependent_host_name)}
  scope :members,                       proc {|members| where(:members => members)}
  scope :dependent_hostgroup_name,      proc {|dependent_hostgroup_name| where(:dependent_hostgroup_name => dependent_hostgroup_name)}
  scope :hostgroup_name,                proc {|hostgroup_name| where(:hostgroup_name => hostgroup_name)}
  scope :inherits_parent,               proc {|inherits_parent| where(:inherits_parent => inherits_parent)}
  scope :execution_failure_criteria,    proc {|execution_failure_criteria| where(:execution_failure_criteria => execution_failure_criteria)}
  scope :notification_failure_criteria, proc {|notification_failure_criteria| where(:notification_failure_criteria => notification_failure_criteria)}
  scope :dependency_period,             proc {|dependency_period| where(:dependency_period => dependency_period)}


  def initialize(*params)
    super(*params)
  end

  private
  def reject_blank_inputs
    members = members.to_a.reject(&:blank?)
  end
end
