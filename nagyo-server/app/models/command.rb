class Command
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields
  include Extensions::DereferencedJson

  # required:
  field :command_name, type: String
  field :command_line, type: String

  has_and_belongs_to_many :hosts
  #??has_many :services

  has_many :host_notification_contacts,
    :class_name => "Contact",
    :inverse_of => :host_notification_commands
  has_many :service_notification_contacts,
    :class_name => "Contact",
    :inverse_of => :service_notification_commands

  has_many :check_command_clusters,
    :class_name => "Cluster",
    :inverse_of => :check_command
  has_many :node_check_command_clusters,
    :class_name => "Cluster",
    :inverse_of => :node_check_command

  has_and_belongs_to_many :hardwareprofiles,
    :class_name => "Hardwareprofile",
    :inverse_of => :check_commands

  #has_and_belongs_to_many :services
  has_many :check_command_services,
    :class_name => "Service",
    :inverse_of => :check_command
  has_many :event_handler_services,
    :class_name => "Service",
    :inverse_of => :event_handler

  validates_uniqueness_of :command_name
  validates_presence_of   :command_name, :command_line

  scope :command_name, proc {|command_name| where(:command_name => command_name) }

  def initialize(*params)
    super(*params)
  end

  def to_s
    "#{command_name}"
  end
end
