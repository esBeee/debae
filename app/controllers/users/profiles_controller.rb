# This controller is responsible for updating the user's profile attributes which are basically
# all, that are not password and email (they should require the currnet password
# to get updated and that's handeled by devise by default).
class Users::ProfilesController < ApplicationController
  layout 'edit_user_registration' # Use the layout specifically designed for this occasion.
  
  before_action :authenticate_user!

  # GET /users/edit/profile
  def edit
    @user = current_user
  end

  # PUT /users/profile
  def update
    # A user exists at this point thanks to
    # our before action.
    @user = current_user

    if @user.update(profile_params)
      flash[:success] = t("users.editings.flashes.success")
      redirect_to edit_user_profile_path
    else
      render :edit
    end
  end


  private

  def profile_params
    params.require(:user).permit(:name, :email_if_new_argument, :avatar)
  end
end
