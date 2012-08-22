class TimeperiodsController < ApplicationController

  has_scope :timeperiod_name
  has_scope :alias

  def index
    @timeperiods = apply_scopes(Timeperiod).all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @timeperiods }
    end
  end

  def new
    @timeperiod = Timeperiod.new
  end

  def create
    @timeperiod = Timeperiod.new(params[:timeperiod])

    respond_to do |format|
      if @timeperiod.save
        format.html { redirect_to(@timeperiod) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def show
    @timeperiod = Timeperiod.find(params[:id])
    render :json => @timeperiod
  end

  def edit
    @timeperiod = Timeperiod.find(params[:id])
  end

  def update
    @timeperiod = Timeperiod.find(params[:id])

    respond_to do |format|
      if @timeperiod.update_attributes(params[:timeperiod])
        format.html { redirect_to @timeperiod, :notice =>  'Timeperiod was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @timeperiod.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @timeperiod = Timeperiod.find(params[:id])
    @timeperiod.destroy

    respond_to do |format|
      format.html { redirect_to timeperiods_url }
      format.json { head :no_content }
    end
  end
end
