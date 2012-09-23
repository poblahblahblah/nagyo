class Contactgroup
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields
  include Extensions::DereferencedJson

  #...?
  #has_and_belongs_to_many :contacts
  has_and_belongs_to_many :members,
    :class_name => "Contact",
    :inverse_of => :contact_groups

  has_and_belongs_to_many :contactgroup_members,
    :class_name => "Contactgroup"

  has_and_belongs_to_many :hosts,
    :class_name => "Host",
    :inverse_of => :contact_groups

  has_and_belongs_to_many :hostescalations,
    :inverse_of => :contact_groups
  has_and_belongs_to_many :serviceescalations,
    :inverse_of => :contact_groups

  # required:
  field :contactgroup_name,     type: String
  field :alias,                 type: String

  # optional:
  #field :members,               type: Array
  #field :contactgroup_members,  type: Array

  # validations
  # FIXME: some of the validations appear to be not working as expected.
  # FIXME: see the host model for an actual explanation.
  validates_presence_of         :contactgroup_name, :alias
  validates_uniqueness_of       :contactgroup_name
  before_validation             :set_alias_to_contactgroup_name

  # FIXME: add validation for not adding contactgroup to itself


  def initialize(*params)
    super(*params)
  end

  def to_s
    "#{contactgroup_name}"
  end

private

  def set_alias_to_contactgroup_name
    self.alias = self.contactgroup_name if self.alias.blank?
  end

end
