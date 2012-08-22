class HostgroupsController < ApplicationController

  has_scope :hostgroup_name
  has_scope :alias
  has_scope :members
  has_scope :hostgroup_members

  def index
    @hostgroups = apply_scopes(Hostgroup).all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @hostgroups }
    end
  end

  def new
    @hostgroup = Hostgroup.new
  end

  def create
    @hostgroup = Hostgroup.new(params[:hostgroup])

    respond_to do |format|
      if @hostgroup.save
        format.html { redirect_to(@hostgroup) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def show
    @hostgroup = Hostgroup.find(params[:id])
    render :json => @hostgroup
  end

  def edit
    @hostgroup = Hostgroup.find(params[:id])
  end

  def update
    @hostgroup = Hostgroup.find(params[:id])

    respond_to do |format|
      if @hostgroup.update_attributes(params[:hostgroup])
        format.html { redirect_to @hostgroup, :notice =>  'Hostgroup was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @hostgroup.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @hostgroup = Hostgroup.find(params[:id])
    @hostgroup.destroy

    respond_to do |format|
      format.html { redirect_to hostgroups_url }
      format.json { head :no_content }
    end
  end
end
