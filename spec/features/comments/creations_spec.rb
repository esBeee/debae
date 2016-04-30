require 'rails_helper'

RSpec.shared_examples "A successful comment creation" do |comment_count|
  it "redirects back to the page of the commented statement" do
    expect(page.current_path).to eq statement_path(statement)
  end

  it "creates a comment for this commentable-user-pair" do
    expect(Comment.where(commentable: statement, user: user, body: valid_body).count).to eq comment_count
  end
end

RSpec.feature "CommentCreations", type: :feature, session_helpers: true do
  let(:user) { FactoryGirl.create(:user) }
  let(:statement) { FactoryGirl.create(:statement) }
  let(:valid_body) { FactoryGirl.attributes_for(:comment)[:body] }

  # Sign in the user and navigate to the page of the
  # statement. Necessary for all cases.
  before do
    # Creations are only allowed for signed in users. So
    # signing in before.
    sign_in user

    visit statement_path(statement)
  end

  describe "creating a valid comment" do
    before do
      fill_in I18n.t("comments.placeholders.body"), with: valid_body
      click_button "comment-statement"
    end

    it_behaves_like "A successful comment creation", 1

    describe "when creating another comment afterwards" do
      before do
        fill_in I18n.t("comments.placeholders.body"), with: valid_body
        click_button "comment-statement"
      end

      it_behaves_like "A successful comment creation", 2
    end
  end

  describe "trying to submit an empty form" do
    before { click_button "comment-statement" }

    it_behaves_like "A successful comment creation", 0

    describe "when creating a valid comment afterwards" do
      before do
        fill_in I18n.t("comments.placeholders.body"), with: valid_body
        click_button "comment-statement"
      end

      it_behaves_like "A successful comment creation", 1
    end
  end
end
