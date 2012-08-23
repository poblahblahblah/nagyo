class HostsController < ApplicationController

  has_scope :host_name
  has_scope :alias
  has_scope :address
  has_scope :check_period
  has_scope :notification_period
  has_scope :contacts
  has_scope :parents
  has_scope :hostgroups
  has_scope :check_command

  def index
    @hosts = apply_scopes(Host).paginate(:page => params[:page])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @hosts }
    end
  end

  def new
    @host = Host.new
  end

  def create
    @host = Host.new(params[:host])

    respond_to do |format|
      if @host.save
        format.html { redirect_to(@host) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def show
    @host = Host.find(params[:id])
    render :json => @host
  end

  def edit
    @host = Host.find(params[:id])
  end

  def update
    @host = Host.find(params[:id])

    respond_to do |format|
      if @host.update_attributes(params[:host])
        format.html { redirect_to @host, :notice =>  'Host was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @host.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @host = Host.find(params[:id])
    @host.destroy

    respond_to do |format|
      format.html { redirect_to hosts_url }
      format.json { head :no_content }
    end
  end
end
