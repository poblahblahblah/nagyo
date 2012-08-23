class ServicesController < ApplicationController

  has_scope :nodegroup
  has_scope :check_command
  has_scope :check_period
  has_scope :notification_period
  has_scope :contacts
  has_scope :servicegroups

  def index
    @services = apply_scopes(Service).paginate(:page => params[:page])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @services }
    end
  end

  def new
    @service = Service.new
  end

  def create
    @service = Service.new(params[:service])

    respond_to do |format|
      if @service.save
        format.html { redirect_to(@service) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def show
    @service = Service.find(params[:id])
    render :json => @service
  end

  def edit
    @service = Service.find(params[:id])
  end

  def update
    @service = Service.find(params[:id])

    respond_to do |format|
      if @service.update_attributes(params[:service])
        format.html { redirect_to @service, :notice => 'Service was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @service = Service.find(params[:id])
    @service.destroy

    respond_to do |format|
      format.html { redirect_to services_url }
      format.json { head :no_content }
    end
  end
end
