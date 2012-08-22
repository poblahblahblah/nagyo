class Hostgroup
  include MongoMapper::Document

  scope :hostgroup_name,	proc {|hostgroup_name| where(:hostgroup_name => hostgroup_name) }
  scope :alias,			proc {|_alias| where(:alias => _alias) }
  scope :members,		proc {|members| where(:members => members) }
  scope :hostgroup_members,	proc {|hostgroup_members| where(:hostgroup_members => hostgroup_members) }

  before_validation :set_alias_and_address_to_host_name

  # hostgroups are functionally the same thing as nodegroups
  # in nventory.
  # required:
  key :hostgroup_name, String, :required => true, :unique => true
  key :alias,          String, :required => true, :unique => true

  # optional:
  key :notes,             String
  key :notes_url,         String
  key :action_url,        String

  # these two are generated automatically from nventory so we'll just leave them out of the view.
  key :members,           String
  key :hostgroup_members, String

  timestamps!

  def initialize(*params)
    super(*params)
  end

  private
  def set_alias_to_hostgroup_name
    self.alias   = self.hostgroup_name if self.alias.empty?
  end
end
