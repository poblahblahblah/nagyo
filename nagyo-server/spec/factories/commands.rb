# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  sequence(:unique_command_name) {|n| "test_command_#{n}" }

  factory :command do
    command_name { generate(:unique_command_name) }
    command_line "echo"

    factory :command_check_host_alive do
      command_name "check-host-alive"
      command_line "$USER1$/check_ping -H $HOSTADDRESS$ -w 3000.0,80% -c 5000.0,100% -p 5"
    end

    factory :command_notify_host_by_email do
      command_name "notify-host-by-email"
      command_line '/usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: $NOTIFICATIONTYPE$\nHost: $HOSTNAME$\nState: $HOSTSTATE$\nAddress: $HOSTADDRESS$\nInfo: $HOSTOUTPUT$\n\nDate/Time: $LONGDATETIME$\n" | /bin/mail -s "** $NOTIFICATIONTYPE$ Host Alert: $HOSTNAME$ is $HOSTSTATE$ **" $CONTACTEMAIL$'
    end

    factory :command_notify_service_by_email do
      command_name "notify-service-by-email"
      command_line '/usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: $NOTIFICATIONTYPE$\n\nService: $SERVICEDESC$\nHost: $HOSTALIAS$\nAddress: $HOSTADDRESS$\nState: $SERVICESTATE$\n\nDate/Time: $LONGDATETIME$\n\nAdditional Info:\n\n$SERVICEOUTPUT$\n" | /bin/mail -s "** $NOTIFICATIONTYPE$ Service Alert: $HOSTALIAS$/$SERVICEDESC$ is $SERVICESTATE$ **" $CONTACTEMAIL$'
    end

    factory :command_process_host_perfdata do
      command_name "process-host-perfdata"
      command_line '/usr/bin/printf "%b" "$LASTHOSTCHECK$\t$HOSTNAME$\t$HOSTSTATE$\t$HOSTATTEMPT$\t$HOSTSTATETYPE$\t$HOSTEXECUTIONTIME$\t$HOSTOUTPUT$\t$HOSTPERFDATA$\n" >> /var/log/nagios/host-perfdata.out'
    end

    factory :command_process_service_perfdata do
      command_name "process-service-perfdata"
      command_line '/usr/bin/printf "%b" "$LASTSERVICECHECK$\t$HOSTNAME$\t$SERVICEDESC$\t$SERVICESTATE$\t$SERVICEATTEMPT$\t$SERVICESTATETYPE$\t$SERVICEEXECUTIONTIME$\t$SERVICELATENCY$\t$SERVICEOUTPUT$\t$SERVICEPERFDATA$\n" >> /var/log/nagios/service-perfdata.out'
    end

    factory :command_check_udp do
      command_name "check_udp"
      command_line "$USER1$/check_udp -H $HOSTADDRESS$ -p $ARG1$ $ARG2$"
    end

    factory :command_check_tcp do
      command_name "check_tcp"
      command_line "$USER1$/check_tcp -H $HOSTADDRESS$ -p $ARG1$ $ARG2$"
    end

    factory :command_check_snmp do
      command_name "check_snmp"
      command_line "$USER1$/check_snmp -H $HOSTADDRESS$ $ARG1$"
    end

    factory :command_check_ping do
      command_name "check_ping"
      command_line "$USER1$/check_ping -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$ -p 5"
    end

    factory :command_check_ssh do
      command_name "check_ssh"
      command_line "$USER1$/check_ssh $ARG1$ $HOSTADDRESS$"
    end


  end
end

