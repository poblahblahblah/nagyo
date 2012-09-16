# NOTE: we are going to ignore this model for now ...
#
class Servicegroup
  include Mongoid::Document
  include Mongoid::Timestamps
  include Extensions::DereferencedJson

  # required:
  field :servicegroup_name,    type: String  #:required => true, :unique => true
  field :alias,                type: String  #:required => true, :unique => true

  # optional:
  field :members,              type: Array
  field :servicegroup_members, type: Array
  field :notes,                type: String
  field :notes_url,            type: String
  field :action_url,           type: String

  scope :servicegroup_name,    proc {|servicegroup_name| where(:servicegroup_name => servicegroup_name) } 
  scope :alias,                proc {|_alias| where(:alias => _alias) } 
  scope :members,              proc {|members| where(:members => members) } 
  scope :servicegroup_members, proc {|servicegroup_members| where(:servicegroup_members => servicegroup_members) } 

  # TODO: should we validate unique :servicegroup_name?

  def initialize(*params)
    super(*params)
  end

  def to_s
    "#{servicegroup_name}"
  end

private

end
