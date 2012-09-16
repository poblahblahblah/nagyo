class Hostdependency
  include Mongoid::Document
  include Mongoid::Timestamps
  include Extensions::DereferencedJson

  belongs_to :dependency_period,
    :class_name => "Timeperiod",
    :inverse_of => :host_dependencies

  # TODO: finish fixing these associations ...
  # FIXME: what is :members?
  #has_many :members, :class_name => "Host" ?

  belongs_to :host,
    :class_name => "Host",
    :inverse_of => :host_dependencies
  belongs_to :dependent_host,
    :class_name => "Host",
    :inverse_of => :dependent_host_dependencies

  belongs_to :hostgroup,
    :class_name => "Hostgroup",
    :inverse_of => :host_dependencies
  belongs_to :dependent_hostgroup,
    :class_name => "Hostgroup",
    :inverse_of => :dependent_host_dependencies

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

  # validations
  # FIXME: TODO: need to check each side of association, but only one required 
  # "The dependent_hostgroup_name may be used instead of, or in addition to, 
  # the dependent_host_name directive."
  #validates_presence_of :host # :unless hostgroup is set
  #validates_presence_of :dependent_host

  validates_with EitherOrValidator, :fields => [:host, :hostgroup]
  validates_with EitherOrValidator, :fields => [:dependent_host, :dependent_hostgroup]

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

end
