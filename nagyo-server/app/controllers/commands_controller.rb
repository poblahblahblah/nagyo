class CommandsController < ApplicationController

  has_scope :command_name

  def index
    @commands = apply_scopes(Command).paginate(:page => params[:page])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @commands }
    end
  end

  def new
    @command = Command.new
  end

  def create
    @command = Command.new(params[:command])

    respond_to do |format|
      if @command.save
        format.html { redirect_to(@command) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def show
    @command = Command.find(params[:id])
    render :json => @command
  end

  def edit
    @command = Command.find(params[:id])
  end

  def update
    @command = Command.find(params[:id])

    respond_to do |format|
      if @command.update_attributes(params[:command])
        format.html { redirect_to @command, :notice =>  'Command was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @command.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @command = Command.find(params[:id])
    @command.destroy

    respond_to do |format|
      format.html { redirect_to commands_url }
      format.json { head :no_content }
    end
  end
end
