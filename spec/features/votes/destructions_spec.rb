require 'rails_helper'

RSpec.shared_examples "A successful destruction" do
  it "destroys the vote" do
    expect(Vote.find_by(id: vote.id)).to eq nil
  end

  it "redirects to the voteable the vote refers to" do
    id = voteable.class == Statement ? voteable : voteable.statement
    expect(page.current_path).to eq statement_path(id)
  end
end

RSpec.feature "VoteDestructions", type: :feature, session_helpers: true do
  let(:user) { vote.user }

  # Sign in the user and navigate to the page of the
  # statement. Necessary for all cases.
  before do
    # Destructions are only possible for signed in users. So
    # signing in before.
    sign_in user
  end

  context "when voteable is a statement" do
    let(:voteable) { FactoryGirl.create(:statement) }

    context "when an up-vote exists" do
      let!(:vote) { FactoryGirl.create(:vote, :up, voteable: voteable) } # Make sure vote was created before tests start with '!'

      before do
        visit statement_path(voteable)

        # Click destroy button
        click_button I18n.t("statements.show.buttons.destroy_upvote")
      end

      it_behaves_like "A successful destruction"
    end

    context "when a down-vote exists" do
      let!(:vote) { FactoryGirl.create(:vote, :down, voteable: voteable) } # Make sure vote was created before tests start with '!'

      before do
        visit statement_path(voteable)

        # Click destroy button
        click_button I18n.t("statements.show.buttons.destroy_downvote")
      end

      it_behaves_like "A successful destruction"
    end
  end

  context "when voteable is an argument (statement-argument-link, to be exact)" do
    let(:voteable) { FactoryGirl.create(:statement_argument_link) }

    context "when an up-vote exists" do
      let!(:vote) { FactoryGirl.create(:vote, :up, voteable: voteable) } # Make sure vote was created before tests start with '!'

      before do
        visit statement_path(voteable.statement)

        # Click destroy button
        click_button I18n.t("statement_argument_links.buttons.destroy_upvote")
      end

      it_behaves_like "A successful destruction"
    end

    context "when a down-vote exists" do
      let!(:vote) { FactoryGirl.create(:vote, :down, voteable: voteable) } # Make sure vote was created before tests start with '!'

      before do
        visit statement_path(voteable.statement)

        # Click destroy button
        click_button I18n.t("statement_argument_links.buttons.destroy_downvote")
      end

      it_behaves_like "A successful destruction"
    end
  end
end
