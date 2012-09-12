class Contactgroup
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields

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
  before_validation             :reject_blank_inputs

  # scopes
  scope :contactgroup_name,     proc {|contactgroup_name| where(:contactgroup_name => contactgroup_name) }
  scope :alias,                 proc {|_alias| where(:alias => _alias) }
  scope :members,               proc {|members| where(:members => members) }
  scope :contactgroup_members,  proc {|contactgroup_members| where(:contactgroup_members => contactgroup_members) }


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

  def reject_blank_inputs
    members = members.to_a.reject(&:blank?)
    contactgroup_members = contactgroup_members.to_a.reject(&:blank?)
  end

end
