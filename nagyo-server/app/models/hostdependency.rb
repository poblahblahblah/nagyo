class Hostdependency
  include MongoMapper::Document

  scope :host_name,			proc {|host_name| where(:host_name => host_name)}
  scope :dependent_host_name,		proc {|dependent_host_name| where(:dependent_host_name => dependent_host_name)}
  scope :members,			proc {|members| where(:members => members)}
  scope :dependent_hostgroup_name,	proc {|dependent_hostgroup_name| where(:dependent_hostgroup_name => dependent_hostgroup_name)}
  scope :hostgroup_name,		proc {|hostgroup_name| where(:hostgroup_name => hostgroup_name)}
  scope :inherits_parent,		proc {|inherits_parent| where(:inherits_parent => inherits_parent)}
  scope :execution_failure_criteria,	proc {|execution_failure_criteria| where(:execution_failure_criteria => execution_failure_criteria)}
  scope :notification_failure_criteria,	proc {|notification_failure_criteria| where(:notification_failure_criteria => notification_failure_criteria)}
  scope :dependency_period,		proc {|dependency_period| where(:dependency_period => dependency_period)}

  # required:
  key :dependent_host_name,		String
  key :host_name,			String

  # optional:
  key :members,				Array
  key :dependent_hostgroup_name,	String
  key :hostgroup_name,			String
  key :inherits_parent,			Integer
  key :execution_failure_criteria,	String
  key :notification_failure_criteria,	String
  key :dependency_period,		String, :default => "workhours"

  timestamps!

  def initialize(*params)
    super(*params)
  end

  private
  def reject_empty_inputs
    members.reject!{|i| i.nil? or i.empty?}
  end
end
