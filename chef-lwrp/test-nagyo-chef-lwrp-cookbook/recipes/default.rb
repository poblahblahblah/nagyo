
# is this how we can test the run?
#
#Chef.log("starting the test")
#

#include_recipe "base::default"

# can we use attributes somehow here to set nagyo-host-url?
#
# add a service --
#
# what is expected to happen when referenced objects don't exist? autovivify 
# nodegroup/hostgroup also?  check_command? contacts?
# 
eharmonyops_nagios_service "a_test_service" do
  # required fields
  name "a test service"
  nodegroup "unix"
  check_command "check_tcp"
  check_command_arguments '$USER1$/check_tcp -H $HOSTADDRESS$ -p $ARG1$ $ARG2$'
  # TODO: contacts needs to be an Array of strings ...
  #contacts []
  contacts "someone@somewhere.com"

  # use this url for testing in default vagrant vm config
  nagyo_url "http://10.0.2.2:3000"
end
