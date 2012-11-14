require 'spec_helper'

describe Host do
  describe "validations" do
    it { should have_and_belong_to_many :contacts }
    it { should have_and_belong_to_many :contact_groups }

    it { should have_and_belong_to_many :hostgroups }
    it { should have_and_belong_to_many :parents }
    it { should have_many :host_dependencies }
    it { should have_many :dependent_host_dependencies }

    it { should have_many :services }
    it { should have_many :service_dependencies }
    it { should have_many :dependent_service_dependencies }

    it { should belong_to :check_command }
    it { should belong_to :event_handler }

    it { should belong_to :check_period }
    it { should belong_to :notification_period }
    it { should belong_to :hardwareprofile }

    it { should have_many :hostescalations }
    it { should have_many :serviceescalations }

    it { should validate_presence_of :host_name }
    it { should validate_presence_of :alias }
    it { should validate_presence_of :address }
    it { should validate_presence_of :max_check_attempts }
    it { should validate_presence_of :check_period }
    it { should validate_presence_of :contacts }
    it { should validate_presence_of :notification_interval }
    it { should validate_presence_of :notification_period }

    #it { should validate_uniqueness_of(:host_name).scoped_to(:check_period, 
    #:contacts, :notification_period) }
    it { should validate_uniqueness_of(:host_name) }


  end
end

