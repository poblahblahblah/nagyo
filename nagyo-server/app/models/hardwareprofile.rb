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

  has_many :hosts,
    :class_name => "Host",
    :inverse_of => :hardwareprofile

  # required:
  field :hardware_profile,      type: String
  slug :hardware_profile

  # validations
  validates_presence_of         :hardware_profile
  validates_uniqueness_of       :hardware_profile

  # NOTE: this has to come *after* the association are defined
  include Extensions::StringableAssociations

  def initialize(*params)
    super(*params)
  end

  def to_s
    "#{hardware_profile}"
  end

private

end
