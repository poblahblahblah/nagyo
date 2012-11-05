require 'spec_helper'

describe Cluster do
  describe "validations" do
    it { should have_and_belong_to_many :contacts }
    it { should belong_to :check_command }
    it { should belong_to :node_check_command }
    it { should belong_to :hostgroup }

    it { should validate_presence_of :hostgroup }
    it { should validate_presence_of :check_command }
    it { should validate_presence_of :check_command_arguments }
    it { should validate_presence_of :contacts }
    it { should validate_presence_of :vip_name }
    it { should validate_uniqueness_of :vip_name }
    it { should validate_presence_of :vip_dns }
    it { should validate_presence_of :node_alert_when_down }
    it { should validate_presence_of :percent_warn }
    it { should validate_presence_of :percent_crit }
    it { should validate_presence_of :ecv_uri }
    it { should validate_presence_of :ecv_string }
  end
end


