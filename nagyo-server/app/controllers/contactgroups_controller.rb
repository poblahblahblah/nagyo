class ContactgroupsController < ApplicationController

  has_scope :contactgroup_name
  has_scope :alias
  has_scope :members
  has_scope :contactgroup_members

  def index
    @contactgroups = apply_scopes(Contactgroup).paginate(:page => params[:page])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @contactgroups }
    end
  end

  def new
    @contactgroup = Contactgroup.new
  end

  def create
    @contactgroup = Contactgroup.new(params[:contactgroup])

    respond_to do |format|
      if @contactgroup.save
        format.html { redirect_to(@contactgroup) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def show
    @contactgroup = Contactgroup.find(params[:id])
    render :json => @contactgroup
  end

  def edit
    @contactgroup = Contactgroup.find(params[:id])
  end

  def update
    @contactgroup = Contactgroup.find(params[:id])

    respond_to do |format|
      if @contactgroup.update_attributes(params[:contactgroup])
        format.html { redirect_to @contactgroup, :notice =>  'Contactgroup was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @Contactgroup.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @contactgroup = Contactgroup.find(params[:id])
    @contactgroup.destroy

    respond_to do |format|
      format.html { redirect_to contactgroups_url }
      format.json { head :no_content }
    end
  end
end
