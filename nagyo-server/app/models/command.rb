class Command
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields

  scope :command_name, proc {|command_name| where(:command_name => command_name) }

  validates_uniqueness_of :command_name

  # required:
  field :command_name, type: String, required: true
  field :command_line, type: String, required: true

  def initialize(*params)
    super(*params)
  end
end
