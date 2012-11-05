require 'spec_helper'

describe Contact do
  describe "associations" do
    it { should have_and_belong_to_many :clusters }
    it { should have_and_belong_to_many :hardwareprofiles }
    it { should have_and_belong_to_many :hosts }
    it { should have_and_belong_to_many :hostescalations }
    it { should have_and_belong_to_many :services }
    it { should have_and_belong_to_many :serviceescalations }
    it { should have_and_belong_to_many :host_notification_commands }
    it { should have_and_belong_to_many :service_notification_commands }
    it { should have_and_belong_to_many :contact_groups
    }
    it { should belong_to :host_notification_period }
    it { should belong_to :service_notification_period }

  end

  describe "validations" do
    it { should validate_presence_of :contact_name }
    it { should validate_uniqueness_of :contact_name }

    it { should validate_presence_of :email }

    # TODO: do we need same validations when association instead of field?
    it { should validate_presence_of :host_notification_period }
    it { should validate_presence_of :host_notification_options }
    it { should validate_presence_of :host_notification_commands }
    it { should validate_presence_of :host_notifications_enabled }
    it { should validate_numericality_of :host_notifications_enabled }

    it { should validate_presence_of :service_notification_period }
    it { should validate_presence_of :service_notification_options }
    it { should validate_presence_of :service_notification_commands }
    it { should validate_presence_of :service_notifications_enabled }
    it { should validate_numericality_of :service_notifications_enabled }

  end
end

