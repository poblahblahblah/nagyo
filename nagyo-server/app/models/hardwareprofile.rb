class Hardwareprofile
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields

  # scopes
  scope :hardware_profile,	proc {|hardware_profile| where(:hardware_profile => hardware_profile) }
  scope :check_commands,	proc {|check_commands| where(:check_commands => check_commands) }
  scope :contacts,              proc {|contacts| where(:contacts => contacts) }

  # validations
  # FIXME: some of the validations appear to be not working as expected.
  # FIXME: see the host model for an actual explanation.
  before_save 			:reject_empty_inputs
  validates_presence_of		:hardware_profile, :check_commands, :contacts
  validates_uniqueness_of	:hardware_profile

  # required:
  field :hardware_profile,	type: String
  field :check_commands,	type: Array
  field :contacts,		type: Array

  def initialize(*params)
    super(*params)
  end

  private
  def reject_empty_inputs
    check_commands.reject!{|i| i.nil? or i.empty?}
    contacts.reject!{|i| i.nil? or i.empty?}
  end
end
