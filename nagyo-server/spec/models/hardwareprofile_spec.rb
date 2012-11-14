require 'spec_helper'

describe Hardwareprofile do
  describe "validations" do
    it { should have_and_belong_to_many :contacts }
    it { should have_and_belong_to_many :check_commands }
    it { should have_many :hosts }

    it { should validate_presence_of :hardware_profile }
    it { should validate_uniqueness_of :hardware_profile }
  end
end
