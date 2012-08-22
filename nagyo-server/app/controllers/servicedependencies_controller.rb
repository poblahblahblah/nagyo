class ServicedependenciesController < ApplicationController

  has_scope :service_name
  has_scope :dependent_service_name
  has_scope :members
  has_scope :dependent_servicegroup_name
  has_scope :servicegroup_name
  has_scope :inherits_parent
  has_scope :execution_failure_criteria
  has_scope :notification_failure_criteria
  has_scope :dependency_period

  def index
    @servicedependencies = apply_scopes(Servicedependency).all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @servicedependencies }
    end
  end

  def new
    @servicedependency = Servicedependency.new
  end

  def create
    @servicedependency = Servicedependency.new(params[:servicedependency])

    respond_to do |format|
      if @servicedependency.save
        format.html { redirect_to(@servicedependency) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def show
    @servicedependency = Servicedependency.find(params[:id])
    render :json => @servicedependency
  end

  def edit
    @servicedependency = Servicedependency.find(params[:id])
  end

  def update
    @servicedependency = Servicedependency.find(params[:id])

    respond_to do |format|
      if @servicedependency.update_attributes(params[:servicedependency])
        format.html { redirect_to @servicedependency, :notice =>  'Service Dependency was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @servicedependency.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @servicedependency = Servicedependency.find(params[:id])
    @servicedependency.destroy

    respond_to do |format|
      format.html { redirect_to servicedependencies_url }
      format.json { head :no_content }
    end
  end
end
