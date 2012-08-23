class Contactgroup
  include MongoMapper::Document

  scope :contactgroup_name,	proc {|contactgroup_name| where(:contactgroup_name => contactgroup_name) }
  scope :alias,			proc {|alias| where(:alias => alias) }
  scope :members,		proc {|members| where(:members => members) }
  scope :contactgroup_members,	proc {|contactgroup_members| where(:contactgroup_members => contactgroup_members) }

  before_validation :set_alias_to_contact_name
  before_save       :reject_empty_inputs

  # required:
  key :contactgroup_name,	String,		:required => true, :unique => true
  key :alias,			String,		:required => true

  # optional:
  key :members,			Array
  key :contactgroup_members,	Array

  timestamps!

  def initialize(*params)
    super(*params)
  end

  private
  def reject_empty_inputs
    contacts.reject!{|i| i.nil? or i.empty?}
    members.reject!{|i| i.nil? or i.empty?}
    contactgroup_members.reject!{|i| i.nil? or i.empty?}
  end
end
