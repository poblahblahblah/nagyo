# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :host do
    host_name                      "test-host"

    contacts { [FactoryGirl.create(:contact)] }

    notification_interval 5
    notification_period { Timeperiod.twentyfourseven }
  end
end

