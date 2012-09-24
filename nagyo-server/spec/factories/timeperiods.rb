# Read about factories at https://github.com/thoughtbot/factory_girl
#
# FIXME: TODO: might need to implement a static db constants method for doing 
# find_or_create_by(:timeperiod_name => "24x7"), since timeperiod_name and 
# alias are supposed to be unique
#   FactoryGirl.create(:timeperiod) will work once, but calling again will FAIL
#

FactoryGirl.define do
  factory :timeperiod do
    timeperiod_name "24x7"
    # TODO: alias is not a good name here - it is a reserved word
    #"alias"  "all-day all-week"

    factory :timeperiod_24x7 do
      timeperiod_name "24x7"
    end

    factory :timeperiod_workhours do
      timeperiod_name "workhours"
    end

    factory :timeperiod_none do
      timeperiod_name "none"
    end

    factory :timeperiod_us_holidays do
      timeperiod_name "us-holidays"
    end

    factory :timeperiod_24x7_sans_holidays do
      timeperiod_name "24x7_sans_holidays"
    end
  end
end

