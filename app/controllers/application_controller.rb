class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


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
    RecalculateStatementScoresJob.perform_later
  end
end
