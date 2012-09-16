class ApplicationController < ActionController::Base
  protect_from_forgery

  # allow anyone to show and index, require auth for other actions
  before_filter :authenticate_user!, :except => [:index, :show]
end
