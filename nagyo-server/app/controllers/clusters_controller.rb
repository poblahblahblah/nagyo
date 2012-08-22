class ClustersController < ApplicationController

  has_scope :nodegroup
  has_scope :check_command
  has_scope :contacts

  def index
    @clusters = apply_scopes(Cluster).all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @clusters }
    end
  end

  def new
    @cluster = Cluster.new
  end

  def create
    @cluster = Cluster.new(params[:cluster])

    respond_to do |format|
      if @cluster.save
        format.html { redirect_to(@cluster) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def show
    @cluster = Cluster.find(params[:id])
    render :json => @cluster
  end

  def edit
    @cluster = Cluster.find(params[:id])
  end

  def update
    @cluster = Cluster.find(params[:id])

    respond_to do |format|
      if @cluster.update_attributes(params[:cluster])
        format.html { redirect_to @cluster, :notice =>  'Cluster was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @cluster.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @cluster = Cluster.find(params[:id])
    @cluster.destroy

    respond_to do |format|
      format.html { redirect_to clusters_url }
      format.json { head :no_content }
    end
  end
end
