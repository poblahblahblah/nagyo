class ServicegroupsController < ApplicationController

  has_scope :servicegroup_name
  has_scope :alias
  has_scope :members
  has_scope :servicegroup_members

  def index
    @servicegroups = apply_scopes(Servicegroup).page params[:page]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @servicegroups }
    end
  end

  def new
    @servicegroup = Servicegroup.new
  end

  def create
    @servicegroup = Servicegroup.new(params[:servicegroup])

    respond_to do |format|
      if @servicegroup.save
        format.html { redirect_to(@servicegroup) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def show
    @servicegroup = Servicegroup.find(params[:id])
    render :json => @servicegroup
  end

  def edit
    @servicegroup = Servicegroup.find(params[:id])
  end

  def update
    @servicegroup = Servicegroup.find(params[:id])

    respond_to do |format|
      if @servicegroup.update_attributes(params[:servicegroup])
        format.html { redirect_to @servicegroup, :notice =>  'Servicegroup was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @servicegroup.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @servicegroup = Servicegroup.find(params[:id])
    @servicegroup.destroy

    respond_to do |format|
      format.html { redirect_to servicegroups_url }
      format.json { head :no_content }
    end
  end
end
