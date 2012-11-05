require 'spec_helper'

describe Serviceescalation do
  describe "validations" do
    it { should belong_to :host }
    it { should belong_to :hostgroup }
    it { should belong_to :service }
    it { should have_and_belong_to_many :contacts }
    it { should have_and_belong_to_many :contact_groups }
    it { should belong_to :escalation_period }

    it { should validate_presence_of :host }
    it { should validate_presence_of :service }
    it { should validate_presence_of :contacts }
    it { should validate_presence_of :contact_groups }
    it { should validate_presence_of :first_notification }
    it { should validate_presence_of :last_notification }
    it { should validate_presence_of :notification_interval }
  end
end


