require 'spec_helper'

describe "RailsAdmin API" do
  it "shows rails_admin index for list" do
    get "/hosts"
    response.should render_template("rails_admin/main/index")
  end

  it "should list in json" do
    get "/hosts.json"
    response.content_type.should == 'application/json'
  end

  it "should have no hosts default" do
    get "/hosts.json"
    response.content_type.should == 'application/json'
    data = JSON.parse(response.body)
    data.should == []
  end

  describe "with factory host" do
    before(:each) do
      @host = FactoryGirl.create :host_no_notifications
    end
    it "should list factory created hosts" do
      get "/hosts.json"
      response.content_type.should == 'application/json'
      data = JSON.parse(response.body)
      data.count.should == 1
      data.first["host_name"].should == @host.host_name
    end

    # NOTE: for filtering details and examples, see:
    #   - rails_admin:spec/unit/adapters/mongoid_spec.rb
    it "can filter list by notifications" do
      @host.notifications_enabled.should_not == 1
      # :o => is, like, between
      get "/hosts.json", :f => { "notifications_enabled" => { "0000" => { :o => "is", :v => 1 }}}
      response.content_type.should == 'application/json'
      data = JSON.parse(response.body)
      data.should == []
    end
  end

  describe "creation via post" do
    # try a timeperiod since has few requirements
    it "should not be allowed unless logged in" do
      post "/timeperiods/new", :timeperiod => { :timeperiod_name => "test-time" }
      response.should redirect_to("/users/sign_in")
    end

    describe "after logging in" do
      before(:each) do
        # user login
        @user = FactoryGirl.create :user
        login(@user)
      end

      it "can create new timeperiod" do
        post "/timeperiods/new", :timeperiod => { :timeperiod_name => "test-time" }
        response.should redirect_to("/timeperiods")
        follow_redirect!

        # now get all, should have ours only
        get "/timeperiods.json"
        data = JSON.parse(response.body)
        data.count.should == 1
        data.first["timeperiod_name"].should == "test-time"
      end

      it "should not be able to create same timeperiod" do
        # make one via Factory, then try making again via POST
        @period = FactoryGirl.create :timeperiod
        name = @period.timeperiod_name

        # should return 406 NotAcceptable
        post "/timeperiods/new", :timeperiod => { :timeperiod_name => name }
        response.code.should == "406"
      end

    end # after login

  end

end

