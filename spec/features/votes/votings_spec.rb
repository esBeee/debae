require 'rails_helper'

RSpec.shared_examples "A successful vote" do |up_or_down|
  it "redirects back to the page of the voted statement" do
    expect(page.current_path).to eq statement_path(statement)
  end

  it "creates an #{up_or_down}-vote for this statement-user-pair" do
    expect(Vote.where(voteable: statement, user: user, is_pro_vote: up_or_down == "up").count).to eq 1
  end

  it "removes all other eventually existing votes for this statement-user-pair" do
    # Test this by checking that there is only one vote for this statement-user-pair:
    # the just created one.
    expect(Vote.where(voteable: statement, user: user).count).to eq 1
  end

  it "disables the #{up_or_down}-vote-button" do
    expect(page).not_to have_button I18n.t("votes.buttons.vote_#{up_or_down}")
  end
end

RSpec.feature "VoteVotings", type: :feature, session_helpers: true do
  let(:user) { FactoryGirl.create(:user) }
  let(:statement) { FactoryGirl.create(:statement) }

  # Sign in the user and navigate to the page of the
  # statement. Necessary for all cases.
  before do
    # Creations are only allowed for signed in users. So
    # signing in before.
    sign_in user

    visit statement_path(statement)
  end

  describe "clicking the up-vote-button" do
    before { click_button I18n.t("votes.buttons.vote_up") }

    it_behaves_like "A successful vote", "up"

    describe "when clicking the down-vote-button afterwards" do
      before { click_button I18n.t("votes.buttons.vote_down") }

      it_behaves_like "A successful vote", "down"
    end
  end

  describe "clicking the down-vote-button" do
    before { click_button I18n.t("votes.buttons.vote_down") }

    it_behaves_like "A successful vote", "down"

    describe "when clicking the up-vote-button afterwards" do
      before { click_button I18n.t("votes.buttons.vote_up") }

      it_behaves_like "A successful vote", "up"
    end
  end
end
