# Overrides devise's registration controller for some individualizations.
class Users::RegistrationsController < Devise::RegistrationsController
  layout 'edit_user_registration', only: :edit # Use the layout specifically designed for this occasion.


  protected

  # This method is used by devise to determin the path to redirect to
  # after a successful registration update.
  def after_update_path_for resource
    edit_user_registration_path
  end
end
