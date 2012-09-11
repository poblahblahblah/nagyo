class Command
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields

  scope :command_name, proc {|command_name| where(:command_name => command_name) }

  # do these need to be habtm? other side is has_one a couple times ...
  has_and_belongs_to_many :clusters
  has_and_belongs_to_many :contacts

  has_and_belongs_to_many :hardwareprofiles
  has_and_belongs_to_many :hosts
  #??has_many :services
  has_and_belongs_to_many :services
  has_and_belongs_to_many :vips


  validates_uniqueness_of :command_name
  validates_presence_of   :command_name, :command_line

  # required:
  field :command_name, type: String
  field :command_line, type: String

  def initialize(*params)
    super(*params)
  end
end
