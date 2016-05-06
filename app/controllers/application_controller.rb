class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Store current path in session to provide "back to last page" functionality
  before_action :store_path

  # Call a function that permits additional attributes for user registrations and account
  # updates, in case this is a devise controller.
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :forelast_visited_path, :beginning_of_history?


  protected
  # Permit additional attributes for user registrationsso the user is
  # able to set his name on sign up.
  # This follows the isntructions of the devise gem readme.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [:name]
  end


  private
  # If a requested resource is not found, this method gets called.
  # It redirects to root path and informs in a flash message.
  def not_found
    flash[:error] = I18n.t("actioncontroller.errors.not_found", default: "Resource could not be found")
    redirect_to :root
  end

  # Verifies that a resource is owned by the currently signed-in
  # user. Returns true in this case.
  # If the verification fails, it returns false and redirects to
  # root path.
  def authenticate_owner! resource
    authorized = true

    # Check if all required resources are defined and if so, check if
    # the owner of the resource equals the signed-in-user.
    # If not all resources are defined, the cause would most likely
    # be an internal flaw.
    if user_signed_in? && !resource.nil?
      unless current_user == resource.user
        authorized = false
      end
    else
      Kazus.log :fatal, "[2jioj4jafod] Unexpected condition.", user_signed_in?, resource
      authorized = false
    end

    # Redirect to root if not authorized.
    unless authorized
      flash[:error] = I18n.t("actioncontroller.errors.unauthorized",
        default: "You are not authorized to direct this action")
      redirect_to :root
    end

    # Return authorized for the calling method to deal with.
    authorized
  end

  # Until a better solution is found, trigger an update of all
  # statements scores in after_actions of certain controller actions.
  def demand_statements_score_update
    RecalculateStatementScoresJob.perform_now
  end

  # Overriding a devise method that gets called after a user has signed out
  # and should return the path, the user gets redirected now.
  def after_sign_out_path_for resource_or_scope
    forelast_visited_path
  end

  # Overriding a devise method that gets called after a user has signed in
  # and should return the path, the user gets redirected now.
  def after_sign_in_path_for resource
    forelast_visited_path
  end

  # Store the current path in session to provide "back to last page" functionality.
  def store_path
    path = request.original_fullpath

    if path.include?("back=1")
      # If the "back" parameter is specified, it means that the "back"-button
      # was used, so instead of adding the current path again, we're removing 
      # the last path.
      session[:last_paths].pop

      redirect_to path.gsub(/(\?|&)back=1/, "")
    elsif request.get? && (path=request.original_fullpath)
      # Initialize last_paths as an empty array if nil
      session[:last_paths] = [] if session[:last_paths].nil?

      unless params[:back]
        # Push the current path if it is not identical with the last path
        session[:last_paths].push(path) unless session[:last_paths].last == path
      end

      # Drop the oldest path if the history is too large.
      while session[:last_paths].count > 50
        session[:last_paths] = session[:last_paths].drop(1)
      end
    end
  end

  # Returns the path the app should redirct to if the user presses the "back"-button.
  def forelast_visited_path
    return "/" if session[:last_paths].nil?
    path = session[:last_paths][-2] || "/"

    unless path.include?("back=1")
      delimiter = path.include?("?") ? "&" : "?"
      path += delimiter + "back=1"
    end

    path
  end

  # Returns a boolean whether there's a path to go back
  # to or this is the beginning of the history.
  def beginning_of_history?
    session[:last_paths].nil? || session[:last_paths].length < 2
  end
end
