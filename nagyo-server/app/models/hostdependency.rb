class Hostdependency
  include Mongoid::Document
  include Mongoid::Timestamps
  include Extensions::DereferencedJson
  include Extensions::SerializedNagiosOptions

  belongs_to :dependency_period,
    :class_name => "Timeperiod",
    :inverse_of => :host_dependencies

  belongs_to :host,
    :class_name => "Host",
    :inverse_of => :host_dependencies
  belongs_to :hostgroup,
    :class_name => "Hostgroup",
    :inverse_of => :host_dependencies

  belongs_to :dependent_host,
    :class_name => "Host",
    :inverse_of => :dependent_host_dependencies
  belongs_to :dependent_hostgroup,
    :class_name => "Hostgroup",
    :inverse_of => :dependent_host_dependencies

  # required:

  # optional:
  field :members,                       type: Array
  field :inherits_parent,               type: Integer
  field :execution_failure_criteria,    type: String
  field :notification_failure_criteria, type: String
  #field :dependency_period, type: String, default: "workhours"

  # these fields copied from association
  field :dependent_host_name, type: String
  field :host_name,           type: String
  field :dependent_hostgroup_name,      type: String
  field :hostgroup_name,                type: String

  before_save :copy_name_fields

  serialize_nagios_options :execution_failure_criteria, :valid => %w{o d u p n}
  serialize_nagios_options :notification_failure_criteria, :valid => %w{o d u p n}

  # validations
  # TODO: does this work to use same class twice?
  validates_with EitherOrValidator, :fields => [:host, :hostgroup]
  validates_with EitherOrValidator, :fields => [:dependent_host, :dependent_hostgroup]


  def initialize(*params)
    super(*params)
  end

private

  def copy_name_fields
    self.host_name           = self.host.host_name rescue nil
    self.dependent_host_name = self.dependent_host.host_name rescue nil
    self.hostgroup_name           = self.hostgroup.hostgroup_name rescue nil
    self.dependent_hostgroup_name = self.dependent_hostgroup.hostgroup_name rescue nil
  end
end
