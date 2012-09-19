class Servicedependency
  include Mongoid::Document
  include Mongoid::Timestamps
  include Extensions::DereferencedJson

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

  validates_presence_of :service, :dependent_service
  validates_with EitherOrValidator, :fields => [:host, :hostgroup]
  validates_with EitherOrValidator, :fields => [:dependent_host, :dependent_hostgroup]


  scope :host_name,                     proc {|host_name| where(:host_name => host_name)}
  scope :hostgroup_name,                proc {|hostgroup_name| where(:hostgroup_name => hostgroup_name)}
  scope :dependent_host_name,           proc {|dependent_host_name| where(:dependent_host_name => dependent_host_name)}
  scope :dependent_hostgroup_name,      proc {|dependent_hostgroup_name| where(:dependent_hostgroup_name => dependent_hostgroup_name)}
  scope :dependent_service_description, proc {|dependent_service_description| where(:dependent_service_description => dependent_service_description)}
  scope :service_description,           proc {|service_description| where(:service_description => service_description)}
  scope :inherits_parent,               proc {|inherits_parent| where(:inherits_parent => inherits_parent)}
  scope :execution_failure_criteria,    proc {|execution_failure_criteria| where(:execution_failure_criteria => execution_failure_criteria)}
  scope :notification_failure_criteria, proc {|notification_failure_criteria| where(:notification_failure_criteria => notification_failure_criteria)}
  scope :dependency_period,             proc {|dependency_period| where(:dependency_period => dependency_period)}

  def initialize(*params)
    super(*params)
  end

protected


  def copy_name_fields
    host_name           = self.host.host_name rescue nil
    hostgroup_name      = self.hostgroup.hostgroup_name rescue nil
    service_description = self.service.name rescue nil
    dependent_host_name           = self.dependent_host.host_name rescue nil
    dependent_hostgroup_name      = self.dependent_hostgroup.hostgroup_name rescue nil
    dependent_service_description = self.dependent_service.name rescue nil
  end

end
