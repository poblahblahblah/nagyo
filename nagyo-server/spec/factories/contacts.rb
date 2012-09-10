# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contact do
    contact_name "Joe Contact"
    email "user@test.com"

    host_notification_commands     []
    service_notification_commands  []
  end
end

