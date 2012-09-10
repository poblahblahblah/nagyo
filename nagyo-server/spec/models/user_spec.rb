require 'spec_helper'

describe User do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :email }
    it { should validate_presence_of :encrypted_password }
  end
end
