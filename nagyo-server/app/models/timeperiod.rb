# timeperiods are pretty ugly, so we'll just specify the names of
# pre-existing time periods so other things can reference them,
# but folks won't be allowed to update/modify them.
#
# TODO: drop use of :alias since that is a reserved ruby keyword - :label or 
# :alias_label and then translate on output to nagios configs
#
class Timeperiod
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields

  # required:
  field :timeperiod_name,       type: String
  field :alias,                 type: String

  #has_many :contacts
  has_many :host_notification_contacts,
    :class_name => "Contact",
    :inverse_of => :host_notification_period
  has_many :service_notification_contacts,
    :class_name => "Contact",
    :inverse_of => :service_notification_period

  #has_many :hosts
  has_many :check_period_hosts,
    :class_name => "Host",
    :inverse_of => :check_period
  has_many :notification_period_hosts,
    :class_name => "Host",
    :inverse_of => :notification_period

  has_many :host_dependencies,
    :class_name => "Hostdependency",
    :inverse_of => :dependency_period

  #has_many :services
  has_many :check_period_services,
    :class_name => "Service",
    :inverse_of => :check_period
  has_many :notification_period_services,
    :class_name => "Service",
    :inverse_of => :notification_period

  has_many :service_dependencies,
    :class_name => "Servicedependency",
    :inverse_of => :dependency_period


  before_validation :ensure_alias_label
  # validations
  validates_presence_of         :timeperiod_name, :alias
  validates_uniqueness_of       :timeperiod_name, :alias

  # scopes
  scope :timeperiod_name,       proc {|timeperiod_name| where(:timeperiod_name => timeperiod_name) }
  scope :alias,                 proc {|_alias| where(:alias => _alias) }


  def initialize(*params)
    super(*params)
  end

  # need some handy methods to grab commonly used periods
  def self.twentyfourseven
    t = Timeperiod.find_or_create_by(:timeperiod_name => "24x7")
    t.save! if t.new_record?
    return t
  end

private

  def ensure_alias_label
    self.alias ||= self.timeperiod_name
  end


end
