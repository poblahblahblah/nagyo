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

    # default list from pat:
    #

    factory :command_check_host_alive do
      command_name "check-host-alive"
      command_line "check-host-alive"
    end

    factory :command_notify_host_by_email do
      command_name "notify-host-by-email"
      command_line "notify-host-by-email"
    end

    factory :command_notify_service_by_email do
      command_name "notify-service-by-email"
      command_line "notify-service-by-email"
    end

    factory :command_process_host_perfdata do
      command_name "process-host-perfdata"
      command_line "process-host-perfdata"
    end

    factory :command_process_service_perfdata do
      command_name "process-service-perfdata"
      command_line "process-service-perfdata"
    end

    factory :command_check_udp do
      command_name "check_udp"
      command_line "check_udp"
    end

    factory :command_check_tcp do
      command_name "check_tcp"
      command_line "check_tcp"
    end

    factory :command_check_snmp do
      command_name "check_snmp"
      command_line "check_snmp"
    end

    factory :command_check_ping do
      command_name "check_ping"
      command_line "check_ping"
    end

    factory :command_check_ssh do
      command_name "check_ssh"
      command_line "check_ssh"
    end


  end
end

