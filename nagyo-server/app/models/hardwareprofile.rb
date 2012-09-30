# EH specific model ...
#
class Hardwareprofile
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields
  include Mongoid::Slug
  include Extensions::DereferencedJson

  has_and_belongs_to_many :contacts
  # habtm?
  has_and_belongs_to_many :check_commands,
    :class_name => "Command",
    :inverse_of => :hardwareprofiles

  # required:
  field :hardware_profile,      type: String
  slug :hardware_profile

  # validations
  validates_presence_of         :hardware_profile
  validates_uniqueness_of       :hardware_profile

  def initialize(*params)
    super(*params)
  end

  def to_s
    "#{hardware_profile}"
  end

private

end
