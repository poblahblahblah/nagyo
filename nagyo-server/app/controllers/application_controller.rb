class ApplicationController < ActionController::Base
  protect_from_forgery

  # allow anyone to show and index, require auth for other actions
  before_filter :authenticate_user!, :except => [:index, :show]

private

  # convert list of options into single comma-separated string field
  def stringify_controller_params(controller, model, key)
    begin
      opts = controller.params[model][key].to_a.reject(&:blank?).sort rescue []
      controller.params[model][key] = opts.join(',')
    rescue
      # nothing to do - maybe params doesn't have the 2 hash levels
    end
  end

end
