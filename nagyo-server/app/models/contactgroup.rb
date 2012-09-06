class Contactgroup
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields

  # scopes
  scope :contactgroup_name,	proc {|contactgroup_name| where(:contactgroup_name => contactgroup_name) }
  scope :alias,			proc {|_alias| where(:alias => _alias) }
  scope :members,		proc {|members| where(:members => members) }
  scope :contactgroup_members,	proc {|contactgroup_members| where(:contactgroup_members => contactgroup_members) }

  # validations
  # FIXME: some of the validations appear to be not working as expected.
  # FIXME: see the host model for an actual explanation.
  validates_presence_of		:contactgroup_name, :alias
  validates_uniqueness_of	:contactgroup_name
  before_validation		:set_alias_to_contactgroup_name
  before_save			:reject_empty_inputs

  # required:
  field :contactgroup_name,	type: String
  field :alias,			type: String

  # optional:
  field :members,		type: Array
  field :contactgroup_members,	type: Array

  def initialize(*params)
    super(*params)
  end

  private
  def set_alias_to_contactgroup_name
    self.alias = self.contactgroup_name if self.alias.empty?
  end

  def reject_empty_inputs
    members.reject!{|i| i.nil? or i.empty?}
    contactgroup_members.reject!{|i| i.nil? or i.empty?}
  end
end
