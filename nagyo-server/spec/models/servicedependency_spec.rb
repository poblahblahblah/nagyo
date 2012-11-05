require 'spec_helper'

describe Servicedependency do
  describe "validations" do
    it { should belong_to :host }
    it { should belong_to :hostgroup }
    it { should belong_to :service }

    it { should belong_to :dependent_host }
    it { should belong_to :dependent_hostgroup }
    it { should belong_to :dependent_service }
    it { should belong_to :dependency_period }

    # TODO: validates with EitherOrValidator

    it { should validate_presence_of :service }
    it { should validate_presence_of :dependent_service }
  end
end


