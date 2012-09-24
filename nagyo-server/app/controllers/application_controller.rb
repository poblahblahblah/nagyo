class ApplicationController < ActionController::Base
  protect_from_forgery

  # NOTE: This is in config/initializers/rails_admin.rb now.
  #
  # allow anyone to show and index, require auth for other actions
  #before_filter :authenticate_user!, :except => [:index, :show]

end
