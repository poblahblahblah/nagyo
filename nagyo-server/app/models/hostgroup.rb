class Hostgroup
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields

  has_and_belongs_to_many :members,
    :class_name => "Host",
    :inverse_of => :hostgroups
    
  # self parenting -- 
  has_and_belongs_to_many :hostgroup_members,
    :class_name => "Hostgroup"

  has_many :service_dependencies,
    :class_name => "Servicedependency",
    :inverse_of => :hostgroup

  has_many :dependent_service_dependencies,
    :class_name => "Servicedependency",
    :inverse_of => :dependent_hostgroup

  has_many :services

  # TODO: replace with associations above ... or better to use :hosts, 
  # :hostgroups and alias for :members?
  #field :members,            type: Array   # Hosts
  #field :hostgroup_members,  type: Array   # Hostgroups

  # hostgroups are functionally the same thing as nodegroups
  # in nventory.
  # required:
  field :hostgroup_name,  type: String
  field :alias,           type: String

  # optional:
  field :notes,           type: String
  field :notes_url,       type: String
  field :action_url,      type: String

  # scopes
  scope :hostgroup_name,    proc {|hostgroup_name| where(:hostgroup_name => hostgroup_name) }
  scope :alias,             proc {|_alias| where(:alias => _alias) }
  scope :members,           proc {|members| where(:members => members) }
  scope :hostgroup_members, proc {|hostgroup_members| where(:hostgroup_members => hostgroup_members) }

  # validations
  before_validation        :set_alias_to_hostgroup_name
  validates_presence_of    :hostgroup_name, :alias
  validates_uniqueness_of  :hostgroup_name, :alias

  def initialize(*params)
    super(*params)
  end

private

  def set_alias_to_hostgroup_name
    self.alias   = self.hostgroup_name if self.alias.blank?
  end

end
