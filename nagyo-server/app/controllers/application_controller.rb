class ApplicationController < ActionController::Base
  protect_from_forgery

  # TODO: will all pages require auth?
  #before_filter :authenticate_user!
end
