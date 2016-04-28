class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Call a function that permits additional attributes for user registrations and account
  # updates, in case this is a devise controller.
  before_action :configure_permitted_parameters, if: :devise_controller?


  protected

  # Permit additional attributes for user registrations and account updates.
  # This follows the isntructions of the devise gem readme.
  def configure_permitted_parameters
    added_attrs = [:name, :email_if_new_argument]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
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
    :back
  end
end
