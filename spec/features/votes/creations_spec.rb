require 'rails_helper'

RSpec.shared_examples "A successful vote" do |up_or_down|
  it "redirects back to the page of the voted voteable" do
    id = voteable.class == Statement ? voteable : voteable.statement
    expect(page.current_path).to eq statement_path(id)
  end

  it "creates an #{up_or_down}-vote for this voteable-user-pair" do
    expect(Vote.where(voteable: voteable, user: user, is_pro_vote: up_or_down == "up").count).to eq 1
  end

  it "removes all other eventually existing votes for this voteable-user-pair" do
    # Test this by checking that there is only one vote for this voteable-user-pair:
    # the just created one.
    expect(Vote.where(voteable: voteable, user: user).count).to eq 1
  end
end

RSpec.shared_examples "A successful vote for a statement" do |up_or_down|
  it_behaves_like "A successful vote", up_or_down

  it "disables the #{up_or_down}-vote-button" do
    # expect(page).to have_css(vote_button_css(up_or_down) + ".pressed")
    expect(page).to have_css(".pressed", text: I18n.t("statements.show.buttons.destroy_#{up_or_down}vote"))
  end
end

RSpec.shared_examples "A successful vote for an argument" do |up_or_down|
  it_behaves_like "A successful vote", up_or_down

  it "disables the #{up_or_down}-vote-button" do
    expect(page).to have_css(".pressed[title='#{I18n.t("statement_argument_links.buttons.destroy_#{up_or_down}vote")}']")
  end
end

RSpec.feature "VoteCreations", type: :feature, session_helpers: true do
  let(:user) { FactoryGirl.create(:user) }
  
  # Sign in the user and navigate to the page of the
  # statement. Necessary for all cases.
  before do
    # Creations are only allowed for signed in users. So
    # signing in before.
    sign_in user
  end

  describe "voting for a statement" do
    let(:voteable) { FactoryGirl.create(:statement) }

    before { visit statement_path(voteable) }

    describe "clicking the up-vote-button" do
      before { click_button I18n.t("statements.show.buttons.vote_up") }

      it_behaves_like "A successful vote for a statement", "up"

      describe "when clicking the down-vote-button afterwards" do
        before { click_button I18n.t("statements.show.buttons.vote_down") }

        it_behaves_like "A successful vote for a statement", "down"
      end
    end

    describe "clicking the down-vote-button" do
      before { click_button I18n.t("statements.show.buttons.vote_down") }

      it_behaves_like "A successful vote for a statement", "down"

      describe "when clicking the up-vote-button afterwards" do
        before { click_button I18n.t("statements.show.buttons.vote_up") }

        it_behaves_like "A successful vote for a statement", "up"
      end
    end
  end

  describe "voting for an argument (or statement-argument-link, to be exact)" do
    let(:voteable) { FactoryGirl.create(:statement_argument_link) }
    let(:statement) { voteable.statement }

    def vote_button_css up_or_down
      title = I18n.t("statement_argument_links.buttons.vote_#{up_or_down}")
      "button[title='#{title}']"
    end

    before { visit statement_path(statement) }

    describe "clicking the up-vote-button" do
      before { find(vote_button_css("up")).click }

      it_behaves_like "A successful vote for an argument", "up"

      describe "when clicking the down-vote-button afterwards" do
        before { find(vote_button_css("down")).click }

        it_behaves_like "A successful vote for an argument", "down"
      end
    end

    describe "clicking the down-vote-button" do
      before { find(vote_button_css("down")).click }

      it_behaves_like "A successful vote for an argument", "down"

      describe "when clicking the up-vote-button afterwards" do
        before { find(vote_button_css("up")).click }

        it_behaves_like "A successful vote for an argument", "up"
      end
    end
  end
end
