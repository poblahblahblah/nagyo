class HardwareprofilesController < ApplicationController

  has_scope :hardware_profile
  has_scope :check_commands

  def index
    @hardwareprofiles = apply_scopes(Hardwareprofile).all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @hardwareprofiles }
    end
  end

  def new
    @hardwareprofile = Hardwareprofile.new
  end

  def create
    @hardwareprofile = Hardwareprofile.new(params[:hardwareprofile])

    respond_to do |format|
      if @hardwareprofile.save
        format.html { redirect_to(@hardwareprofile) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def show
    @hardwareprofile = Hardwareprofile.find(params[:id])
    render :json => @hardwareprofile
  end

  def edit
    @hardwareprofile = Hardwareprofile.find(params[:id])
  end

  def update
    @hardwareprofile = Hardwareprofile.find(params[:id])

    respond_to do |format|
      if @hardwareprofile.update_attributes(params[:hardwareprofile])
        format.html { redirect_to @hardwareprofile, :notice =>  'Hardwareprofile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @hardwareprofile.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @hardwareprofile = Hardwareprofile.find(params[:id])
    @hardwareprofile.destroy

    respond_to do |format|
      format.html { redirect_to hardwareprofiles_url }
      format.json { head :no_content }
    end
  end
end
