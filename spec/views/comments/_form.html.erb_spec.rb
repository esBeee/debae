require 'rails_helper'

RSpec.describe "comments/_form", type: :view do
  let(:form_css_path) { "form" }
  let(:sign_in_message) do
    I18n.t("comments.sign_in_to_comment_html",
      link_to_sign_in: link_to(I18n.t("comments.links.sign_in"), new_user_session_path))
  end

  context "when no user is signed in" do
    before { render }

    it "displays the reason the user can't comment" do
      expect(rendered).to include(sign_in_message)
    end

    it "doesn't display the comment form" do
      expect(rendered).not_to have_css(form_css_path)
    end
  end

  context "when a user is signed in" do
    let(:user) { FactoryGirl.create(:user) }
    let(:commentable) { FactoryGirl.create(:statement) }

    before do
      sign_in user
      render "form", commentable: commentable
    end

    it "doesn't display the reason the user can't comment" do
      expect(rendered).not_to include(sign_in_message)
    end

    it "displays the comment form" do
      expect(rendered).to have_css(form_css_path)
    end
  end
end
