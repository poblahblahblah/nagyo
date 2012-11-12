# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :host do
    host_name                      "test-host"

    contacts { [FactoryGirl.create(:contact)] }

    notification_interval 5
    notification_period { Timeperiod.twentyfourseven }


    factory :host_no_notifications do
      host_name                      "test-host-quiet"
      notifications_enabled 0
      notification_period { Timeperiod.workhours }
    end
  end
end

