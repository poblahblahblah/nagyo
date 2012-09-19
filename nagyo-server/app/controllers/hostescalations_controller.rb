class HostescalationsController < ApplicationController

  def index
    @hostescalations = apply_scopes(Hostescalation).page params[:page]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @hostescalations }
    end
  end

  def new
    @hostescalation = Hostescalation.new
  end

  def create
    @hostescalation = Hostescalation.new(params[:hostescalation])

    respond_to do |format|
      if @hostescalation.save
        format.html { redirect_to(@hostescalation) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def show
    @hostescalation = Hostescalation.find(params[:id])
    render :json => @hostescalation
  end

  def edit
    @hostescalation = Hostescalation.find(params[:id])
  end

  def update
    @hostescalation = Hostescalation.find(params[:id])

    respond_to do |format|
      if @hostescalation.update_attributes(params[:hostescalation])
        format.html { redirect_to @hostescalation, :notice =>  'HostEscalation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @hostescalation.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @hostescalation = Hostescalation.find(params[:id])
    @hostescalation.destroy

    respond_to do |format|
      format.html { redirect_to hostescalations_url }
      format.json { head :no_content }
    end
  end
end
