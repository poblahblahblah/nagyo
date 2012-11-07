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
      @host = FactoryGirl.create :host
    end
    it "should list factory created hosts" do
      get "/hosts.json"
      response.content_type.should == 'application/json'
      data = JSON.parse(response.body)
      data.count.should == 1
      data.first["host_name"].should == @host.host_name
    end

    it "can filter list" do
      @host.status.should_not == "inservice"
      get "/hosts.json", :f => { "status" => { "0000" => { :o => "like", :v => "inservice" }}}
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

    it "should create new" do
      # user login
      @user = FactoryGirl.create :user
      login(@user)

      post "/timeperiods/new", :timeperiod => { :timeperiod_name => "test-time" }
      response.should redirect_to("/timeperiods")
      follow_redirect!

      # not get all and should have ours only
      get "/timeperiods.json"
      data = JSON.parse(response.body)
      data.count.should == 1
      data.first["timeperiod_name"].should == "test-time"
    end

  end

end

