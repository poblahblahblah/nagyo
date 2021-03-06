class Servicedependency
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields
  include Extensions::DereferencedJson
  include Extensions::SerializedNagiosOptions

  # these are the things we are depending upon:
  belongs_to :host,      :inverse_of => :service_dependencies
  belongs_to :hostgroup, :inverse_of => :service_dependencies
  belongs_to :service,   :inverse_of => :service_dependencies

  # this is the dependent which depends on the items above
  belongs_to :dependent_host,
    :class_name => "Host",
    :inverse_of => :dependent_service_dependencies

  belongs_to :dependent_hostgroup,
    :class_name => "Hostgroup",
    :inverse_of => :dependent_service_dependencies

  belongs_to :dependent_service,
    :class_name => "Service",
    :inverse_of => :dependent_service_dependencies

  belongs_to :dependency_period,
    :class_name => "Timeperiod",
    :inverse_of => :service_dependencies
  
  # required:
  field :dependent_service_description, type: String
  field :service_description,           type: String

  # optional:
  field :inherits_parent,               type: Integer
  field :execution_failure_criteria,    type: String
  field :notification_failure_criteria, type: String
  #field :dependency_period,             type: String

  # these fields are generated from association values
  field :dependent_host_name,           type: String
  field :host_name,                     type: String
  field :dependent_hostgroup_name,      type: String
  field :hostgroup_name,                type: String

  before_save :copy_name_fields

  serialize_nagios_options :execution_failure_criteria, :valid => %w{o w u c p n}
  serialize_nagios_options :notification_failure_criteria, :valid => %w{o w u c p n}
  
  validates_presence_of :service, :dependent_service
  validates_with EitherOrValidator, :fields => [:host, :hostgroup]
  validates_with EitherOrValidator, :fields => [:dependent_host, :dependent_hostgroup]

  # NOTE: this has to come *after* the association are defined
  include Extensions::StringableAssociations


  def initialize(*params)
    super(*params)
  end

protected


  def copy_name_fields
    self.host_name           = self.host.host_name rescue nil
    self.hostgroup_name      = self.hostgroup.hostgroup_name rescue nil
    self.service_description = self.service.name rescue nil
    self.dependent_host_name           = self.dependent_host.host_name rescue nil
    self.dependent_hostgroup_name      = self.dependent_hostgroup.hostgroup_name rescue nil
    self.dependent_service_description = self.dependent_service.name rescue nil
  end

end
