require 'rails_helper'

RSpec.shared_examples "Basic header content" do
  it "displays logo" do
    expect(rendered).to have_content("debae")
  end
end

RSpec.describe "layouts/_header", type: :view do

  let(:user) {  FactoryGirl.create(:user) }
  let(:sign_out_link_xpath) { "//a[@href='#{destroy_user_session_path}'][@data-method='delete']" +
    "[text()='#{I18n.t("layouts.header.links.sign_out")}']" }
  
  context "when user is signed in" do
    before do
      sign_in user
      render
    end

    include_examples "Basic header content"

    it "doesn't display link to sign in" do
      expect(rendered).not_to have_link(I18n.t("layouts.header.links.sign_in"))
    end

    it "doesn't display link to sign up" do
      expect(rendered).not_to have_link(I18n.t("layouts.header.links.sign_up"))
    end

    it "displays link to sign out" do
      expect(rendered).to have_xpath(sign_out_link_xpath)
    end
  end

  context "when no user is signed in" do
    before { render }

    include_examples "Basic header content"

    it "displays link to sign in" do
      expect(rendered).to have_link(I18n.t("layouts.header.links.sign_in"), href: new_user_session_path)
    end

    it "displays link to sign up" do
      expect(rendered).to have_link(I18n.t("layouts.header.links.sign_up"), href: new_user_registration_path)
    end
  end
end
