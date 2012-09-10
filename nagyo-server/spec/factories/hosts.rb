# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :host do
    host_name                      "test-host"

    # TODO: make this real association
    #contacts { [FactoryGirl.create(:contact)] }
    contacts { ["Test User"] }
  end
end

