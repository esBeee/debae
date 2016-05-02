require 'rails_helper'

RSpec.describe "layouts/_email_reminder", type: :view do
  let(:user) { FactoryGirl.create(:user) }

  context "when user is signed in" do
    before { sign_in user }
    context "when user has a verified email address" do
      before do
        render
      end

      it "displays nothing" do
        expect(rendered).to eq ""
      end
    end

    context "when user has not stated an email yet" do
      before do
        user.email = ""
        user.save! validate: false

        render
      end

      it "displays a warning" do
        expect(rendered).to include(I18n.t(
          "users.reminders.email_missing_html",
          link_to_account_settings: link_to(t("users.reminders.link_to_account_settings"),edit_user_registration_path))
        )
      end
    end

    context "when user has an email waiting for confirmation" do
      before do
        user.unconfirmed_email = "gr@qwd.ce"
        user.save! validate: false
        
        render
      end

      it "displays a warning" do
        expect(rendered).to include(I18n.t("users.reminders.email_unconfirmed_html", email_address: user.unconfirmed_email))
      end
    end
  end

  context "when no user is signed in" do
    before { render }

    it "displays nothing" do
      expect(rendered).to eq ""
    end
  end
end
