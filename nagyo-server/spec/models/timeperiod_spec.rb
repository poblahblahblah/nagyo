require 'spec_helper'

describe Timeperiod do
  describe "validations" do
    it { should have_many :host_notification_contacts }
    it { should have_many :service_notification_contacts }
    it { should have_many :check_period_hosts }
    it { should have_many :notification_period_hosts }
    it { should have_many :host_dependencies }
    it { should have_many :service_dependencies }
    it { should have_many :check_period_services }
    it { should have_many :notification_period_services }
    it { should have_many :hostescalations }
    it { should have_many :serviceescalations }

    it { should validate_presence_of :timeperiod_name }
    it { should validate_uniqueness_of :timeperiod_name }
    it { should validate_presence_of :alias }
    it { should validate_uniqueness_of :alias }
  end
end

