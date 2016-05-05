# Overrides devise's registration controller for some individualizations.
class Users::RegistrationsController < Devise::RegistrationsController
  layout 'edit_user_registration', only: :edit # Use the layout specifically designed for this occasion.


  protected

  # Override devise's update_resource method to allow
  # updating the email address, if it's currently blank,
  # without the current password.
  def update_resource resource, params
    # If changes don't affect the password (i.e. only the email address) and
    # if the current email address is blank (that might be the case if the
    # user used OAuth), allow changes without the current password.
    if params[:password].blank? && resource.email.blank?
      # The current password is not handled in this case.
      params.delete(:current_password)

      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  # This method is used by devise to determin the path to redirect to
  # after a successful registration update.
  def after_update_path_for resource
    edit_user_registration_path
  end
end
