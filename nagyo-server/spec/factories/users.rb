# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "Test User"
    email "user@test.com"
    password "please"
    password_confirmation "please"
    authentication_token "nagyo-token-test-user"
  end
end
