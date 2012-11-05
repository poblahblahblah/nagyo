require 'spec_helper'

describe Hostgroup do
  describe "validations" do
    it { should have_and_belong_to_many :members }
    it { should have_and_belong_to_many :hostgroup_members }

    it { should have_many :host_dependencies }
    it { should have_many :dependent_host_dependencies }
    it { should have_many :service_dependencies }
    it { should have_many :dependent_service_dependencies }
    it { should have_many :clusters }
    it { should have_many :services }
    it { should have_many :hostescalations }
    it { should have_many :serviceescalations }

    it { should validate_presence_of :hostgroup_name }
    it { should validate_presence_of :alias }
    it { should validate_uniqueness_of :hostgroup_name }
    it { should validate_uniqueness_of :alias }
  end
end

