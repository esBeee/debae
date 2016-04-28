require 'rails_helper'

RSpec.shared_examples "A successful user registration" do
  it "should save the user's data" do
    # The user should have been created.
    expect(last_created_user).not_to be nil

    expect(last_created_user.email).to eq user[:email]
    expect(last_created_user.valid_password?(user[:password])).to eq true
    expect(last_created_user.name).to eq user[:name]
  end

  it "redirects to root path" do
    expect(page.current_path).to eq root_path
  end
end

RSpec.feature "UserRegistrations", type: :feature do
  let(:user) { FactoryGirl.attributes_for(:user, password: "foobar12", name: "Tom") }
  let(:last_created_user) { User.order(:created_at).last }
  
  before do
    visit new_user_registration_path
  end

  def fill_in_user_registration_form values = {}
    fill_in I18n.t("users.registrations.labels.email"), with: values[:email] || user[:email]
    fill_in I18n.t("users.registrations.labels.password"), with: values[:password] || user[:password]
    fill_in I18n.t("users.registrations.labels.password_confirmation"), with: values[:password_confirmation] || user[:password]
    fill_in I18n.t("users.editings.labels.name"), with: values[:name] || user[:name]
  end

  context "with valid data" do
    before do
      fill_in_user_registration_form

      # Submit the form.
      click_button I18n.t("users.registrations.buttons.submit")
    end

    it_behaves_like "A successful user registration"
  end

  context "with invalid data" do
    before do
      fill_in_user_registration_form(password_confirmation: user[:password] + "a")

      # Submit the form.
      click_button I18n.t("users.registrations.buttons.submit")
    end

    it "should not create a user" do
      expect(last_created_user).to eq nil
    end

    it "displays error message" do
      expect(page).to have_content("Password confirmation stimmt nicht mit Password überein")
    end

    describe "correcting the error afterwards" do
      before do
        fill_in_user_registration_form

        # Submit the form.
        click_button I18n.t("users.registrations.buttons.submit")
      end

      it_behaves_like "A successful user registration"
    end
  end
end
