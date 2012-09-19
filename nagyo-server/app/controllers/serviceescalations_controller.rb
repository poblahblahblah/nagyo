class ServiceescalationsController < ApplicationController

  def index
    @serviceescalations = apply_scopes(Serviceescalation).page params[:page]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @serviceescalations }
    end
  end

  def new
    @serviceescalation = Serviceescalation.new
  end

  def create
    @serviceescalation = Serviceescalation.new(params[:serviceescalation])

    respond_to do |format|
      if @serviceescalation.save
        format.html { redirect_to(@serviceescalation) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def show
    @serviceescalation = Serviceescalation.find(params[:id])
    render :json => @serviceescalation
  end

  def edit
    @serviceescalation = Serviceescalation.find(params[:id])
  end

  def update
    @serviceescalation = Serviceescalation.find(params[:id])

    respond_to do |format|
      if @serviceescalation.update_attributes(params[:serviceescalation])
        format.html { redirect_to @serviceescalation, :notice =>  'ServiceEscalation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @serviceescalation.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @serviceescalation = Serviceescalation.find(params[:id])
    @serviceescalation.destroy

    respond_to do |format|
      format.html { redirect_to serviceescalations_url }
      format.json { head :no_content }
    end
  end
end
