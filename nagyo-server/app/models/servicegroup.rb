class Servicegroup
  include MongoMapper::Document

  scope :servicegroup_name	proc {|servicegroup_name| where(:servicegroup_name => servicegroup_name) } 
  scope :alias,			proc {|alias| where(:alias => alias) } 
  scope :members,		proc {|members| where(:members => members) } 
  scope :servicegroup_members,	proc {|servicegroup_members| where(:servicegroup_members => servicegroup_members) } 

  # required:
  key :servicegroup_name,		String,	:required => true, :unique => true
  key :alias,				String,	:required => true, :unique => true

  # optional:
  key :members,                         Array
  key :servicegroup_members,		Array
  key :notes,				String
  key :notes_url,			String
  key :action_url,			String

  timestamps!

  def initialize(*params)
    super(*params)
  end

  private
  def reject_empty_inputs
    members.reject!{|i| i.nil? or i.empty?}
    servicegroup_members.reject!{|i| i.nil? or i.empty?}
  end
end
