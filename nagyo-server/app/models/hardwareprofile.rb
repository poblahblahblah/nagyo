class Hardwareprofile
  include MongoMapper::Document

  scope :hardware_profile,	proc {|hardware_profile| where(:hardware_profile => hardware_profile) }
  scope :check_commands,	proc {|check_commands| where(:check_commands => check_commands) }

  before_save :reject_empty_inputs

  # required:
  key :hardware_profile,	String,	:required => true, :unique => true
  key :check_commands,		Array, 	:required => true

  timestamps!

  def initialize(*params)
    super(*params)
  end

  private
  def reject_empty_inputs
    check_commands.reject!{|i| i.nil? or i.empty?}
  end
end
