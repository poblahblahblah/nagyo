# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  sequence(:unique_command_name) {|n| "Test Command #{n}" }

  factory :command do
    command_name { generate(:unique_command_name) }
    command_line "echo"


    factory :command_ls do
      command_name "Directory list"
      command_line "ls"
    end

    factory :command_ps do
      command_name "Process list"
      command_line "ps"
    end
  end
end

