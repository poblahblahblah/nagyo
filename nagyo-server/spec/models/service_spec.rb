require 'spec_helper'

describe Service do
  describe "validations" do
    it { should belong_to :host }
    it { should belong_to :hostgroup }
    it { should have_and_belong_to_many :contacts }
    it { should belong_to :check_command }
    it { should belong_to :event_handler }
    it { should belong_to :check_period }
    it { should belong_to :notification_period }

    it { should have_many :service_dependencies }
    it { should have_many :dependent_service_dependencies }
    it { should have_and_belong_to_many :servicegroups }
    it { should have_many :serviceescalations }

    # TODO: validates with EitherOrValidator

    it { should validate_presence_of :name }
    it { should validate_presence_of :check_command }
    it { should validate_presence_of :check_command_arguments }
    it { should validate_presence_of :max_check_attempts }
    it { should validate_presence_of :check_interval }
    it { should validate_presence_of :check_period }
    it { should validate_presence_of :notification_interval }
    it { should validate_presence_of :notification_period }
    it { should validate_presence_of :contacts }
  end
end


