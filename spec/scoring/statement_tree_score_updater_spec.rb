require 'rails_helper'

RSpec.describe StatementTreeScoreUpdater, type: :model do
  describe "#self.update_all" do
    context "when no statements exist" do
      it "doesn't throw an error" do
        expect(StatementTreeScoreUpdater.update_all()).to eq true
      end
    end

    context "when one statements exist" do
      let!(:statement) { FactoryGirl.create(:statement) }
      let!(:vote) { FactoryGirl.create(:vote, :up, voteable: statement) } # one vote should be enough for the score not to be nil

      before { StatementTreeScoreUpdater.update_all() }

      it "updates the statement's score" do
        expect(statement.reload.score).to eq 1.0
      end
    end

    context "when several statements exist" do
      # Designing a test graph like this. Note that there's an in-built loop.
      #
      #     [s]       [s_4]--->[s_i]
      #    /   \     /        /
      #   /     [s_2] <______/
      # [a] ___/                   [s_5]
      #
      let!(:link) { FactoryGirl.create(:statement_argument_link) }
      let!(:s) { link.statement }
      let!(:a) { link.argument }

      let!(:link_3) { FactoryGirl.create(:statement_argument_link, statement: s) }

      let!(:s_2) { link_3.argument }

      let!(:link_2) { FactoryGirl.create(:statement_argument_link, statement: s_2, argument: a) }

      let!(:s_4) { FactoryGirl.create(:statement_argument_link, argument: s_2).statement }

      let!(:s_5) { FactoryGirl.create(:statement) }

      let!(:s_i) { FactoryGirl.create(:statement) }
      let!(:link_4) { FactoryGirl.create(:statement_argument_link, statement: s_i, argument: s_4) }
      let!(:link_5) { FactoryGirl.create(:statement_argument_link, statement: s_2, argument: s_i) }

      # Also, give the only ground statement a few votes. That should lead to every argument
      # except s_5 having a score.
      before do
        FactoryGirl.create_list(:vote, 12, :up, voteable: a)
      end

      it "should fill in the score for all statements if sufficient information is available" do
        # First, make sure no score is assigned by now
        expect(Statement.where.not(score: nil).count).to eq 0

        StatementTreeScoreUpdater.update_all()

        # Expect a score for every but one statement
        expect(Statement.where.not(score: nil).count).to eq Statement.count - 1

        # Expect that the only statement without score is s_5
        expect(Statement.find_by(score: nil)).to eq s_5
      end
    end
  end
end
