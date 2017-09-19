require 'rails_helper'

RSpec.shared_examples "Basic header content" do
  it "displays logo" do
    expect(rendered).to have_content("debae")
  end

  it "displays a link to the contact page" do
    expect(rendered).to have_link(contact_page, href: contact_path)
  end
end

RSpec.describe "layouts/_header", type: :view do
  let(:user) {  FactoryGirl.create(:user) }
  let(:sign_out_link_xpath) { "//a[@href='#{destroy_user_session_path}'][@data-method='delete']" +
    "[contains(text(),'#{I18n.t("layouts.header.links.sign_out")}')]" }

  let(:contact_page) { I18n.t("layouts.header.links.contact") }
  let(:sign_in_with_email) { I18n.t("layouts.header.links.sign_in", auth_type: "Email") }
  let(:sign_in_with_facebook) { I18n.t("layouts.header.links.sign_in", auth_type: "Facebook") }
  let(:sign_in_with_google) { I18n.t("layouts.header.links.sign_in", auth_type: "Google") }
  let(:sign_in_with_twitter) { I18n.t("layouts.header.links.sign_in", auth_type: "Twitter") }

  context "when user is signed in" do
    before do
      sign_in user
      render template: "layouts/_header", locals: { forelast_visited_path: "/" }
    end

    include_examples "Basic header content"

    it "doesn't display link to sign in with email" do
      expect(rendered).not_to have_link(sign_in_with_email)
    end

    it "doesn't display link to sign in with facebook" do
      expect(rendered).not_to have_link(sign_in_with_facebook)
    end

    it "doesn't display link to sign in with google" do
      expect(rendered).not_to have_link(sign_in_with_google)
    end

    it "doesn't display link to sign in with twitter" do
      expect(rendered).not_to have_link(sign_in_with_twitter)
    end

    it "displays link to sign out" do
      expect(rendered).to have_xpath(sign_out_link_xpath)
    end
  end

  context "when no user is signed in" do
    before { render template: "layouts/_header", locals: { forelast_visited_path: "/" } }

    include_examples "Basic header content"

    it "displays link to sign in with email" do
      expect(rendered).to have_link(sign_in_with_email, href: new_user_session_path)
    end

    it "displays link to sign in with facebook" do
      expect(rendered).to have_link(sign_in_with_facebook, href: user_facebook_omniauth_authorize_path)
    end

    it "displays link to sign in with google" do
      expect(rendered).to have_link(sign_in_with_google, href: user_google_oauth2_omniauth_authorize_path)
    end

    it "displays link to sign in with twitter" do
      expect(rendered).to have_link(sign_in_with_twitter, href: user_twitter_omniauth_authorize_path)
    end
  end
end
