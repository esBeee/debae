class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # If the requested resource is not found, this method gets called.
  # It renders a 404 page and stops execution immediately.
  def not_found
    raise ActionController::RoutingError.new("Not Found")
  end
end
