class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # After a OAuth request, this function gets called with the auth information
  # in request.env["omniauth.auth"].
  # def facebook
  #   Kazus.log :info, "facebook OAuth callback called", auth_hash: request.env["omniauth.auth"]

  #   # Get a user object from the available OAuth data.
  #   @user = User::OAuthHandler.from_omniauth(request.env["omniauth.auth"])

  #   # I expect the above method :from_omniauth to always return a
  #   # persisted user. Keeping the 'else' just in case.
  #   if @user.persisted?
  #     begin
  #       sign_in_and_redirect @user # this will throw if @user is not activated
  #     rescue Exception => e
  #       Kazus.log :warn, "Just tried to sign in a user after successful OAuth, but got an exception " +
  #         "(user might not be confirmed)", exception: e, user: @user
  #       redirect_to root_path
  #     end
  #     set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
  #   else
  #     # It would be unexpected if this case would occur. But just in case...
  #     Kazus.log :warn, "After OAuth data processing, no persisted user exists", user: @user, auth_hash: request.env["omniauth.auth"]
  #     session["devise.facebook_data"] = request.env["omniauth.auth"]
  #     redirect_to new_user_registration_url
  #   end
  # end

  def self.provides_callback_for provider
    class_eval %Q{
      def #{provider}
        Kazus.log :info, "#{provider} OAuth callback called", auth_hash: request.env["omniauth.auth"]

        # Get a user object from the available OAuth data.
        @user = User::OAuthHandler.from_omniauth(request.env["omniauth.auth"])

        # I expect the above method :from_omniauth to always return a
        # persisted user. Keeping the 'else' just in case.
        if @user.persisted?
          begin
            sign_in_and_redirect @user # this will throw if @user is not activated
          rescue Exception => e
            Kazus.log :warn, "Just tried to sign in a user after successful OAuth, but got an exception " +
              "(user might not be confirmed)", exception: e, user: @user
            redirect_to root_path
          end
          set_flash_message(:notice, :success, kind: "#{provider.capitalize}") if is_navigational_format?
        else
          # It would be unexpected if this case would occur. But just in case...
          Kazus.log :warn, "After OAuth data processing, no persisted user exists", user: @user, auth_hash: request.env["omniauth.auth"]
          session["devise.#{provider}_data"] = request.env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
    }
  end

  [:twitter, :facebook].each do |provider|
    provides_callback_for(provider)
  end

  # After a OAuth request, this function gets called with the auth information
  # in request.env["omniauth.auth"].
  # def twitter
  #   Kazus.log :info, "twitter OAuth callback called", auth_hash: request.env["omniauth.auth"]

  #   # Get a user object from the available OAuth data.
  #   @user = User::OAuthHandler.from_omniauth(request.env["omniauth.auth"])

  #   # I expect the above method :from_omniauth to always return a
  #   # persisted user. Keeping the 'else' just in case.
  #   if @user.persisted?
  #     begin
  #       sign_in_and_redirect @user # this will throw if @user is not activated
  #     rescue Exception => e
  #       Kazus.log :warn, "Just tried to sign in a user after successful OAuth, but got an exception " +
  #         "(user might not be confirmed)", exception: e, user: @user
  #       redirect_to root_path
  #     end
  #     set_flash_message(:notice, :success, kind: "Twitter") if is_navigational_format?
  #   else
  #     # It would be unexpected if this case would occur. But just in case...
  #     Kazus.log :warn, "After OAuth data processing, no persisted user exists", user: @user, auth_hash: request.env["omniauth.auth"]
  #     session["devise.twitter_data"] = request.env["omniauth.auth"]
  #     redirect_to new_user_registration_url
  #   end
  # end

  def failure
    redirect_to root_path
  end
end
