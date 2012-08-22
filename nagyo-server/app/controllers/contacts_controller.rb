class ContactsController < ApplicationController

  has_scope :contact_name
  has_scope :email
  has_scope :host_notification_period
  has_scope :service_notification_period

  def index
    @contacts = apply_scopes(Contact).all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @contacts }
    end
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])

    respond_to do |format|
      if @contact.save
        format.html { redirect_to(@contact) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def show
    @contact = Contact.find(params[:id])
    render :json => @contact
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to @contact, :notice =>  'Contact was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @Contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.json { head :no_content }
    end
  end
end
