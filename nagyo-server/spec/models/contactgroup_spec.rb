require 'spec_helper'

describe Contactgroup do
  describe "validations" do
    it { should have_and_belong_to_many :members }
    it { should have_and_belong_to_many :contactgroup_members }
    it { should have_and_belong_to_many :hosts }
    it { should have_and_belong_to_many :hostescalations }
    it { should have_and_belong_to_many :serviceescalations }

    it { should validate_presence_of :contactgroup_name }
    it { should validate_uniqueness_of :contactgroup_name }
    it { should validate_presence_of :alias }
  end
end


