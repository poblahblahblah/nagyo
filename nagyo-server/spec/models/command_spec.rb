require 'spec_helper'

describe Command do
  describe "validations" do
    it { should have_and_belong_to_many :hosts }
    it { should have_and_belong_to_many :hardwareprofiles }

    it { should have_many :host_notification_contacts }
    it { should have_many :service_notification_contacts }
    it { should have_many :check_command_clusters }
    it { should have_many :node_check_command_clusters }
    it { should have_many :check_command_services }
    it { should have_many :event_handler_services }

    it { should validate_presence_of :command_name }
    it { should validate_uniqueness_of :command_name }
    it { should validate_presence_of :command_line }
  end
end

