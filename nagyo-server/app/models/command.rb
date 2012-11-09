class Command
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Fields
  include Mongoid::Slug
  include Extensions::DereferencedJson

  # required:
  field :command_name, type: String
  slug :command_name

  field :command_line, type: String

  #has_and_belongs_to_many :hosts,
  #  :class_name => "Host",
  #  :inverse_of => :check_command
  has_many :check_command_hosts,
    :class_name => "Host",
    :inverse_of => :check_command
  has_many :event_handler_hosts,
    :class_name => "Host",
    :inverse_of => :event_handler
  
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

  # NOTE: this has to come *after* the association are defined
  include Extensions::StringableAssociations

  validates_uniqueness_of :command_name
  validates_presence_of   :command_name, :command_line


  def initialize(*params)
    super(*params)
  end

  def to_s
    "#{command_name}!#{command_line}"
  end

  def to_label
    "#{command_name}"
  end
end
