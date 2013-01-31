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
  factory_user = FactoryGirl.build(:user)
  puts "*** Building User #{factory_user.email}"
  db_user = User.find_or_create_by(:email => factory_user.email)
  if db_user
    # get around attr-protected settings
    factory_user.attributes.each do |k,v|
      next if k.to_s == "_id"
      begin
	puts "Setting #{k}= #{v}"
        db_user.send("#{k}=", v) 
      rescue
        puts "Unable to set attribute on user: #{$!}"
      end
    end
    puts "db_user= #{db_user.inspect}"
    puts "db_user.errors= #{db_user.errors.inspect}"
    db_user.save!
  end
rescue
  puts "*** Unable to create or have already created default user: #{$!}"
end

# timeperiods
puts "*** Building Timeperiods ... "
timeperiods = FactoryGirl.factories.select { |x| x.send(:class_name).to_s.downcase == "timeperiod" }
timeperiods.each do |factory|
  FactoryGirl.create(factory.name) rescue nil
end

# commands
puts "*** Building Commands ... "
commands = FactoryGirl.factories.select { |x| x.send(:class_name).to_s.downcase == "command" }
commands.each do |factory|
  begin
    factory_command = FactoryGirl.build(factory.name)
    db_command = Command.find_or_create_by(:command_name => factory_command.command_name)
    # don't want to update all opts - just command_line ?
    if db_command
      db_command.update_attributes(:command_line => factory_command.command_line)
      db_command.save
    end
  rescue
    puts "Unable to create or have already created command '#{factory_command}': #{$!}"
  end
end


# TODO: is db seed_fu a better thing than factory girl for this usage?
# factory-girl cannot easily update existing records :(
