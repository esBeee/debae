# Contains methods that are useful if a test requires a session to be active.
module SessionHelpers
  # Just signes the user in via the regular form (so no stubbing).
  def sign_in user
    email = user.email
    password = user.password

    # Happens if the user was reloaded from the database after creation.
    raise 'NoUserPassword' if password.nil?

    # Visit sign-in-page
    visit new_user_session_path

    # Fill in credentials
    fill_in I18n.t("devise.sessions.new.email_label"), with: email
    fill_in I18n.t("devise.sessions.new.password_label"), with: password

    # Submit
    click_button I18n.t("devise.sessions.new.submit_button_value")
  end
end
