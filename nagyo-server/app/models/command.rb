class Command
  include MongoMapper::Document

  scope :command_name, proc {|command_name| where(:command_name => command_name) }

  # required:
  key :command_name, String, :required => true, :unique => true
  key :command_line, String, :required => true

  timestamps!

  def initialize(*params)
    super(*params)
  end
end
