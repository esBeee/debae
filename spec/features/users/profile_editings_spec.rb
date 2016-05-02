require 'rails_helper'

RSpec.shared_examples "A successful user profile editing" do
  it "should save the user's data" do
    user.reload # Make sure the attributes we compare are up-to-date.
    expect(user.name).to eq edited_user_attributes[:name]
    expect(user.link_to_facebook).to eq edited_user_attributes[:link_to_facebook]
    expect(user.link_to_twitter).to eq edited_user_attributes[:link_to_twitter]
    expect(user.link_to_google_plus).to eq edited_user_attributes[:link_to_google_plus]
    expect(user.email_if_new_argument).to eq edited_user_attributes[:email_if_new_argument]
  end

  it "stays on the settings page" do
    expect(page.current_path).to eq edit_user_profile_path
  end

  it "displays flash success message" do
    expect(page).to have_content(I18n.t("users.editings.flashes.success"))
  end
end

RSpec.feature "UserProfileEditings", type: :feature, session_helpers: true do
  let(:user) { FactoryGirl.create(:user, name: "Tom", email_if_new_argument: true, link_to_facebook: "https://www.facebook.com/old",
    link_to_google_plus: "https://www.google.com/old", link_to_twitter: "https://www.twitter.com/old") }
  let(:edited_user_attributes) { FactoryGirl.attributes_for(:user, name: "Tommy", email_if_new_argument: false,
    link_to_facebook: "https://www.facebook.com/new", link_to_google_plus: "https://www.google.com/new",
    link_to_twitter: "https://www.twitter.com/new") }
  
  before do
    # It's required that the user is signed in
    sign_in user

    visit edit_user_profile_path
  end

  # Only updates fills in the attributes that don't require the current password.
  def fill_in_user_form values = {}
    fill_in I18n.t("users.editings.labels.name"), with: values[:name] || edited_user_attributes[:name]
    fill_in I18n.t("users.editings.labels.link_to_facebook"), with: values[:link_to_facebook] || edited_user_attributes[:link_to_facebook]
    fill_in I18n.t("users.editings.labels.link_to_google_plus"), with: values[:link_to_google_plus] || edited_user_attributes[:link_to_google_plus]
    fill_in I18n.t("users.editings.labels.link_to_twitter"), with: values[:link_to_twitter] || edited_user_attributes[:link_to_twitter]

    if values[:email_if_new_argument] || edited_user_attributes[:email_if_new_argument]
      check(I18n.t("users.editings.labels.email_if_new_argument"))
    else
      uncheck(I18n.t("users.editings.labels.email_if_new_argument"))
    end
  end

  context "with valid data" do
    before do
      fill_in_user_form

      # Submit the form.
      click_button I18n.t("users.editings.buttons.submit")
    end

    it_behaves_like "A successful user profile editing"
  end

  context "with invalid data" do
    let(:invalid_name) { "T" }

    before do
      # Fill in an invalid name.
      fill_in_user_form(name: invalid_name)

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
        fill_in_user_form

        # Submit the form.
        click_button I18n.t("users.editings.buttons.submit")
      end

      it_behaves_like "A successful user profile editing"
    end
  end
end
