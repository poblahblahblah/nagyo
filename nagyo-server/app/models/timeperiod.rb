class Timeperiod
  include MongoMapper::Document

  scope :timeperiod_name,	proc {|timeperiod_name| where(:timeperiod_name => timeperiod_name) }
  scope :alias,			proc {|_alias| where(:alias => _alias) }

  # timeperiods are pretty ugly, so we'll just specify the names of
  # pre-existing time periods so other things can reference them,
  # but folks won't be allowed to update/modify them.

  # required:
  key :timeperiod_name,	String, :required => true, :unique => true
  key :alias, 		String, :required => true, :unique => true

  timestamps!

  def initialize(*params)
    super(*params)
  end
end
