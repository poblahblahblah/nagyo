# NOTE: hostgroups are functionally the same thing as nodegroups in 
# nventory.
class Hostgroup
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields
  include Mongoid::Slug
  include Extensions::DereferencedJson

  has_and_belongs_to_many :members,
    :class_name => "Host",
    :inverse_of => :hostgroups
    
  # self parenting -- 
  has_and_belongs_to_many :hostgroup_members,
    :class_name => "Hostgroup"

  has_many :host_dependencies,
    :class_name => "Hostdependency",
    :inverse_of => :hostgroup
  has_many :dependent_host_dependencies,
    :class_name => "Hostdependency",
    :inverse_of => :dependent_hostgroup

  has_many :service_dependencies,
    :class_name => "Servicedependency",
    :inverse_of => :hostgroup
  has_many :dependent_service_dependencies,
    :class_name => "Servicedependency",
    :inverse_of => :dependent_hostgroup

  has_many :clusters
  has_many :services
  has_many :hostescalations
  has_many :serviceescalations

  # required:
  field :hostgroup_name,  type: String
  slug :hostgroup_name

  field :alias,           type: String

  # optional:
  field :notes,           type: String
  field :notes_url,       type: String
  field :action_url,      type: String

  # validations
  before_validation        :set_alias_to_hostgroup_name
  validates_presence_of    :hostgroup_name, :alias
  validates_uniqueness_of  :hostgroup_name, :alias

  # NOTE: this has to come *after* the association are defined
  include Extensions::StringableAssociations

  def initialize(*params)
    super(*params)
  end

  def to_s
    "#{hostgroup_name}"
  end

private

  def set_alias_to_hostgroup_name
    self.alias   = self.hostgroup_name if self.alias.blank?
  end

end
