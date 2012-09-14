# EH specific model ...
#
class Hardwareprofile
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields

  has_and_belongs_to_many :contacts
  # habtm?
  has_and_belongs_to_many :check_commands,
    :class_name => "Command",
    :inverse_of => :hardwareprofiles

  # required:
  field :hardware_profile,      type: String
  #field :check_commands,        type: Array
  #field :contacts,              type: Array

  # validations
  before_validation             :reject_blank_inputs
  validates_presence_of         :hardware_profile
  validates_uniqueness_of       :hardware_profile

  # scopes
  scope :hardware_profile,      proc {|hardware_profile| where(:hardware_profile => hardware_profile) }
  scope :check_commands,        proc {|check_commands| where(:check_commands => check_commands) }
  scope :contacts,              proc {|contacts| where(:contacts => contacts) }

  def initialize(*params)
    super(*params)
  end

  def to_s
    "#{hardware_profile}"
  end

private

  def reject_blank_inputs
    check_commands = check_commands.to_a.reject(&:blank?)
    contacts = contacts.to_a.reject(&:blank?)
  end

end
