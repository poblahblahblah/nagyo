# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :command do
    command_name "Test Command"
    command_line "test"


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

