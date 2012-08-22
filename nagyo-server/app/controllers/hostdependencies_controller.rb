class HostdependenciesController < ApplicationController

  has_scope :host_name
  has_scope :dependent_host_name
  has_scope :members
  has_scope :dependent_hostgroup_name
  has_scope :hostgroup_name
  has_scope :inherits_parent
  has_scope :execution_failure_criteria
  has_scope :notification_failure_criteria
  has_scope :dependency_period

  def index
    @hostdependencies = apply_scopes(Hostdependency).all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @hostdependencies }
    end
  end

  def new
    @hostdependency = Hostdependency.new
  end

  def create
    @hostdependency = Hostdependency.new(params[:hostdependency])

    respond_to do |format|
      if @hostdependency.save
        format.html { redirect_to(@hostdependency) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def show
    @hostdependency = Hostdependency.find(params[:id])
    render :json => @hostdependency
  end

  def edit
    @hostdependency = Hostdependency.find(params[:id])
  end

  def update
    @hostdependency = Hostdependency.find(params[:id])

    respond_to do |format|
      if @hostdependency.update_attributes(params[:hostdependency])
        format.html { redirect_to @hostdependency, :notice =>  'Host Dependency was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @hostdependency.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @hostdependency = Hostdependency.find(params[:id])
    @hostdependency.destroy

    respond_to do |format|
      format.html { redirect_to hostdependencies_url }
      format.json { head :no_content }
    end
  end
end
