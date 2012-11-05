require 'spec_helper'

describe Servicegroup do
  describe "validations" do
    it { should have_and_belong_to_many :members }
    it { should have_and_belong_to_many :servicegroup_members }

    it { should validate_presence_of :servicegroup_name }
    it { should validate_uniqueness_of :servicegroup_name }
    it { should validate_presence_of :alias }
  end
end
