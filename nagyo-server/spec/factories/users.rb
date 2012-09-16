# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "Test User"
    email "user@test.com"
    password "please"
    password_confirmation "please"
    #confirmed_at { Time.now }
  end
end
