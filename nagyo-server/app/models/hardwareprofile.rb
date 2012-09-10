class Hardwareprofile
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields

  # scopes
  scope :hardware_profile,      proc {|hardware_profile| where(:hardware_profile => hardware_profile) }
  scope :check_commands,        proc {|check_commands| where(:check_commands => check_commands) }
  scope :contacts,              proc {|contacts| where(:contacts => contacts) }

  # validations
  before_validation             :reject_blank_inputs
  validates_presence_of         :hardware_profile
  validates_uniqueness_of       :hardware_profile

  # required:
  field :hardware_profile,      type: String
  field :check_commands,        type: Array
  field :contacts,              type: Array

  def initialize(*params)
    super(*params)
  end

private

  def reject_blank_inputs
    check_commands = check_commands.to_a.reject(&:blank?)
    errors.add(:check_commands, "please select at least one check_command.") if check_commands.count == 0

    contacts = contacts.to_a.reject(&:blank?)
    errors.add(:contacts, "please select at least one contact.") if contacts.count == 0
  end

end
