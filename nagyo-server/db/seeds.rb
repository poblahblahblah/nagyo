# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
#

# This creates a default User called user@test.com, password: please
#     not friendly with duplicates

begin
  FactoryGirl.create(:user)
rescue
  puts "Unable to create or have already created default user: #{$!}"
end


