class Timeperiod
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields

  has_many :contacts
  has_many :host_dependencies
  has_many :hosts
  has_many :service_dependencies
  has_many :services

  # scopes
  scope :timeperiod_name,	proc {|timeperiod_name| where(:timeperiod_name => timeperiod_name) }
  scope :alias,			proc {|_alias| where(:alias => _alias) }

  # validations
  validates_presence_of 	:timeperiod_name, :alias
  validates_uniqueness_of	:timeperiod_name, :alias

  # timeperiods are pretty ugly, so we'll just specify the names of
  # pre-existing time periods so other things can reference them,
  # but folks won't be allowed to update/modify them.

  # required:
  field :timeperiod_name,	type: String
  field :alias, 		type: String

  def initialize(*params)
    super(*params)
  end
end
