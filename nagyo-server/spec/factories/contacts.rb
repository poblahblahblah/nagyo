# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contact do
    contact_name "Joe Contact"
    email "user@test.com"

    # TODO: get these to be proper associations
    host_notification_commands     { [FactoryGirl.create(:command)] }
    service_notification_commands  { [FactoryGirl.create(:command)] }
  end
end

