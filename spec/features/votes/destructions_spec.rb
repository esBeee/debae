require 'rails_helper'

RSpec.shared_examples "A successful destruction" do
  it "destroys the vote" do
    expect(Vote.find_by(id: vote.id)).to eq nil
  end

  it "redirects to the statement the vote refers to" do
    expect(page.current_path).to eq statement_path(statement)
  end
end

RSpec.feature "VoteDestructions", type: :feature, session_helpers: true do
  let(:user) { vote.user }
  let(:statement) { vote.voteable }

  # Sign in the user and navigate to the page of the
  # statement. Necessary for all cases.
  before do
    # Destructions are only possible for signed in users. So
    # signing in before.
    sign_in user
  end

  context "when an up-vote exists" do
    let!(:vote) { FactoryGirl.create(:vote, :up) } # Make sure vote was created before tests start with '!'

    before do
      visit statement_path(statement)

      # Click destroy button
      click_button I18n.t("votes.buttons.destroy_up_vote")
    end

    it_behaves_like "A successful destruction"
  end

  context "when an down-vote exists" do
    let!(:vote) { FactoryGirl.create(:vote, :down) } # Make sure vote was created before tests start with '!'

    before do
      visit statement_path(statement)

      # Click destroy button
      click_button I18n.t("votes.buttons.destroy_down_vote")
    end

    it_behaves_like "A successful destruction"
  end
end
