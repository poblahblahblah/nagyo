# NOTE: we are going to ignore this model for now ...
#
class Servicegroup
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields
  include Mongoid::Slug
  include Extensions::DereferencedJson

  has_and_belongs_to_many :members,
    :class_name => "Service",
    :inverse_of => :servicegroups

  has_and_belongs_to_many :servicegroup_members,
    :class_name => "Servicegroup"

  # NOTE: this has to come *after* the association are defined
  include Extensions::StringableAssociations

  # required:
  field :servicegroup_name,    type: String  #:required => true, :unique => true
  slug :servicegroup_name

  field :alias,                type: String  #:required => true, :unique => true

  # optional:
  field :notes,                type: String
  field :notes_url,            type: String
  field :action_url,           type: String

  before_validation        :set_alias_to_servicegroup_name
  validates_presence_of    :servicegroup_name, :alias
  validates_uniqueness_of  :servicegroup_name

  def initialize(*params)
    super(*params)
  end

  def to_s
    "#{servicegroup_name}"
  end

protected

  def set_alias_to_servicegroup_name
    self.alias = self.servicegroup_name if self.alias.blank?
  end

end
