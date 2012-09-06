class Command
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields

  scope :command_name, proc {|command_name| where(:command_name => command_name) }

  validates_uniqueness_of :command_name
  validates_presence_of   :command_name, :command_line

  # required:
  field :command_name, type: String
  field :command_line, type: String

  def initialize(*params)
    super(*params)
  end
end
