class VipsController < ApplicationController

  has_scope :hostgroup
  has_scope :vip_name
  has_scope :vip_dns
  has_scope :check_command
  has_scope :ecv_uri
  has_scope :ecv_string
  has_scope :contacts

  def index
    @vips = apply_scopes(Vip).page params[:page]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @vips }
    end
  end

  def new
    @vip = Vip.new
  end

  def create
    @vip = Vip.new(params[:vip])

    respond_to do |format|
      if @vip.save
        format.html { redirect_to(@vip) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def show
    @vip = Vip.find(params[:id])
    render :json => @vip
  end

  def edit
    @vip = Vip.find(params[:id])
  end

  def update
    @vip = Vip.find(params[:id])

    respond_to do |format|
      if @vip.update_attributes(params[:vip])
        format.html { redirect_to @vip, :notice =>  'Vip was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @vip.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @vip = Vip.find(params[:id])
    @vip.destroy

    respond_to do |format|
      format.html { redirect_to vips_url }
      format.json { head :no_content }
    end
  end
end
