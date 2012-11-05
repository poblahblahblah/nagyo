require 'spec_helper'

describe Hostdependency do
  describe "validations" do
    it { should belong_to :dependency_period }
    it { should belong_to :host }
    it { should belong_to :hostgroup }
    it { should belong_to :dependent_host }
    it { should belong_to :dependent_hostgroup }

    # TODO: validates EitherOrValidator


  end
end

