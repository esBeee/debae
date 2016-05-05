require 'rails_helper'

RSpec.shared_examples "A successful user editing" do
  it "should save the user's data" do
    user.reload # Make sure the attributes we compare are up-to-date.
    expect(user.unconfirmed_email).to eq edited_user_attributes[:email]
    expect(user.valid_password?(edited_user_attributes[:password])).to eq true
  end

  it "stays on the settings page" do
    expect(page.current_path).to eq edit_user_registration_path
  end

  it "displays flash success message" do
    expect(page).to have_content(I18n.t("devise.registrations.update_needs_confirmation"))
  end
end

RSpec.feature "UserEditings", type: :feature, session_helpers: true do
  let(:user) { FactoryGirl.create(:user, password: "foobar12") }
  let(:edited_user_attributes) { FactoryGirl.attributes_for(:user, password: "foobar13", email: "g@a.to") }
  
  before do
    # It's required that the user is signed in
    sign_in user

    visit edit_user_registration_path
  end

  def fill_in_user_form values = {}
    fill_in I18n.t("users.editings.labels.email"), with: values[:email] || edited_user_attributes[:email]
    fill_in I18n.t("users.editings.labels.password"), with: values[:password] || edited_user_attributes[:password]
    fill_in I18n.t("users.editings.labels.password_confirmation"), with: values[:password_confirmation] || edited_user_attributes[:password]
    fill_in I18n.t("users.editings.labels.current_password"), with: values[:password] || user.password
  end

  context "with valid data" do
    context "when filling in the current password correctly" do
      before do
        fill_in_user_form

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
          fill_in I18n.t("users.editings.labels.current_password"), with: user.password + "s"

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
        context "when email address is not blank before" do
          before do
            # Trying to change the user's email only.
            fill_in I18n.t("users.editings.labels.email"), with: edited_user_attributes[:email]

            # Filling in an invalid password.
            fill_in I18n.t("users.editings.labels.current_password"), with: user.password + "s"

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

        context "when email address is blank before" do
          before do
            # Make sure the user's email is blank.
            user.email = ""
            user.save! validate: false

            # Trying to change the user's email only.
            fill_in I18n.t("users.editings.labels.email"), with: edited_user_attributes[:email]

            # Submit the form.
            click_button I18n.t("users.editings.buttons.submit")
          end

          it "should update the user's email" do
            user.reload # Make sure the attributes we compare are up-to-date.
            expect(user.unconfirmed_email).to eq edited_user_attributes[:email]
          end
        end
      end
    end
  end

  context "with invalid data" do
    let(:invalid_email) { "a@g" }

    before do
      # Fill in an invalid name.
      fill_in_user_form(email: invalid_email)

      # Submit the form.
      click_button I18n.t("users.editings.buttons.submit")
    end

    it "should not update the user's attributes" do
      user.reload # Make sure the attributes we compare are up-to-date.
      expect(user.unconfirmed_email).not_to eq invalid_email
    end

    it "displays an error message" do
      expect(page).to have_content("Email ist nicht gültig")
    end

    context "when using valid data afterwards" do
      before do
        fill_in_user_form

        # Submit the form.
        click_button I18n.t("users.editings.buttons.submit")
      end

      it_behaves_like "A successful user editing"
    end
  end
end
