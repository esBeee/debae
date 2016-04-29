require 'rails_helper'

RSpec.shared_examples "A successful user editing" do |insensitive_attributes_only|
  it "should save the user's data" do
    user.reload # Make sure the attributes we compare are up-to-date.

    unless insensitive_attributes_only
      # These are the attributes that require the current password to
      # be changed.
      expect(user.unconfirmed_email).to eq edited_user_attributes[:email]
      expect(user.valid_password?(edited_user_attributes[:password])).to eq true
    end

    expect(user.name).to eq edited_user_attributes[:name]
    expect(user.email_if_new_argument).to eq edited_user_attributes[:email_if_new_argument]
  end

  it "stays on the settings page" do
    expect(page.current_path).to eq edit_user_registration_path
  end

  it "displays flash success message" do
    if insensitive_attributes_only
      message = I18n.t("devise.registrations.updated")
    else
      message = I18n.t("devise.registrations.update_needs_confirmation")
    end

    expect(page).to have_content(message)
  end
end

RSpec.feature "UserEditings", type: :feature, session_helpers: true do
  let(:user) { FactoryGirl.create(:user, password: "foobar12", name: "Tom") }
  let(:edited_user_attributes) { FactoryGirl.attributes_for(:user, password: "foobar13",
    name: "Tommy", email: "g@a.to", email_if_new_argument: false) }
  
  before do
    # It's required that the user is signed in
    sign_in user

    # Kazus.log edited_user_attributes

    visit edit_user_registration_path
  end

  # Only updates fills in the attributes that don't require the current password.
  def fill_in_user_registration_form_insensitive_attributes values = {}
    fill_in I18n.t("users.editings.labels.name"), with: values[:name] || edited_user_attributes[:name]

    if values[:email_if_new_argument] || edited_user_attributes[:email_if_new_argument]
      check(I18n.t("users.editings.labels.email_if_new_argument"))
    else
      uncheck(I18n.t("users.editings.labels.email_if_new_argument"))
    end
  end

  def fill_in_user_registration_form values = {}
    fill_in I18n.t("users.editings.labels.email"), with: values[:email] || edited_user_attributes[:email]
    fill_in I18n.t("users.editings.labels.password"), with: values[:password] || edited_user_attributes[:password]
    fill_in I18n.t("users.editings.labels.password_confirmation"), with: values[:password_confirmation] || edited_user_attributes[:password]
    fill_in_user_registration_form_insensitive_attributes(values)
  end

  def fill_in_current_password values = {}
    fill_in I18n.t("users.editings.labels.current_password"), with: values[:password] || user.password
  end

  context "with valid data" do
    context "when filling in the current password correctly" do
      before do
        fill_in_user_registration_form
        fill_in_current_password

        # Submit the form.
        click_button I18n.t("users.editings.buttons.submit")
      end

      it_behaves_like "A successful user editing"
    end

    context "when not filling in the current password correctly" do
      context "when trying to change the password" do
        before do
          # Trying to change the user's password only.
          fill_in I18n.t("users.editings.labels.password"), with: edited_user_attributes[:password]
          fill_in I18n.t("users.editings.labels.password_confirmation"), with: edited_user_attributes[:password]

          # Filling in an invalid password.
          fill_in_current_password(password: user.password + "s")

          # Submit the form.
          click_button I18n.t("users.editings.buttons.submit")
        end

        it "should not update the user's attributes" do
          user.reload # Make sure the attributes we compare are up-to-date.
          expect(user.valid_password?(edited_user_attributes[:password])).to eq false
        end

        it "displays error message" do
          expect(page).to have_content("Current password ist nicht gültig")
        end
      end

      context "when trying to change the email" do
        before do
          # Trying to change the user's password only.
          fill_in I18n.t("users.editings.labels.email"), with: edited_user_attributes[:email]

          # Filling in an invalid password.
          fill_in_current_password(password: user.password + "s")

          # Submit the form.
          click_button I18n.t("users.editings.buttons.submit")
        end

        it "should not update the user's attributes" do
          user.reload # Make sure the attributes we compare are up-to-date.
          expect(user.unconfirmed_email).to eq nil
        end

        it "displays error message" do
          expect(page).to have_content("Current password ist nicht gültig")
        end
      end
    end

    context "when not filling in the current password at all" do
      context "when neither changing the email address nor the password" do
        before do
          # Trying to change the user's password only.
          fill_in_user_registration_form_insensitive_attributes

          # Submit the form.
          click_button I18n.t("users.editings.buttons.submit")
        end

        # Check that the attributes have been updated and more.
        it_behaves_like "A successful user editing", true
      end
    end
  end

  context "with invalid data" do
    let(:invalid_name) { "T" }
    before do
      # Fill in an invalid name.
      fill_in_user_registration_form(name: invalid_name)
      fill_in_current_password

      # Submit the form.
      click_button I18n.t("users.editings.buttons.submit")
    end

    it "should not update the user's attributes" do
      user.reload # Make sure the attributes we compare are up-to-date.
      expect(user.name).not_to eq invalid_name
    end

    it "displays an error message" do
      expect(page).to have_content("Name ist zu kurz")
    end

    context "when using valid data afterwards" do
      before do
        fill_in_user_registration_form
        fill_in_current_password

        # Submit the form.
        click_button I18n.t("users.editings.buttons.submit")
      end

      it_behaves_like "A successful user editing"
    end
  end
end