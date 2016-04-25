require 'rails_helper'

RSpec.describe Statement::Scoring, type: :model do
  describe "#self.calculate_score" do
    let(:statement) { FactoryGirl.create(:statement) }

    context "when neither votes nor arguments exist for the given statement" do
      it "returns nil" do
        expect(Statement::Scoring.calculate_score(statement)).to eq nil
      end
    end

    context "when only votes exist" do
      it "returns 1 if only up-votes exist" do
        FactoryGirl.create(:vote, :up, statement: statement)
        expect(Statement::Scoring.calculate_score(statement)).to eq 1
      end

      it "returns 0 if only down-votes exist" do
        FactoryGirl.create(:vote, :down, statement: statement)
        expect(Statement::Scoring.calculate_score(statement)).to eq 0
      end

      it "returns 0.5 if an equally amount of down- and up-votes exist" do
        FactoryGirl.create(:vote, :down, statement: statement)
        FactoryGirl.create(:vote, :up, statement: statement)
        expect(Statement::Scoring.calculate_score(statement)).to eq 0.5
      end
    end

    context "when only arguments exist" do
      it "returns some number if a pro argument with a score of 1.0 exists" do
        argument = FactoryGirl.create(:statement, score: 1.0)
        FactoryGirl.create(:statement_argument_link, :pro, statement: statement, argument: argument)
        expect(Statement::Scoring.calculate_score(statement)).to eq 0.8354035060960472
      end

      it "returns 1 - x, where x is the score for the pro argument if a contra argument with a score of 1.0 exists" do
        argument = FactoryGirl.create(:statement, score: 1.0)
        FactoryGirl.create(:statement_argument_link, :contra, statement: statement, argument: argument)
        expect(Statement::Scoring.calculate_score(statement)).to eq 1 - 0.8354035060960472
      end

      it "returns some number if two pro arguments and one contra argument exist" do
        argument = FactoryGirl.create(:statement, score: 0.8)
        FactoryGirl.create(:statement_argument_link, :pro, statement: statement, argument: argument)

        argument = FactoryGirl.create(:statement, score: 0.8)
        FactoryGirl.create(:statement_argument_link, :pro, statement: statement, argument: argument)

        argument = FactoryGirl.create(:statement, score: 0.9)
        FactoryGirl.create(:statement_argument_link, :contra, statement: statement, argument: argument)

        expect(Statement::Scoring.calculate_score(statement)).to eq 0.557663582872025
      end

      it "returns nil if a contra argument with a score of 0.0 exists" do
        argument = FactoryGirl.create(:statement, score: 0.0)
        FactoryGirl.create(:statement_argument_link, :contra, statement: statement, argument: argument)
        expect(Statement::Scoring.calculate_score(statement)).to eq nil
      end

      it "returns nil if a pro argument with a score of 0.0 exists" do
        argument = FactoryGirl.create(:statement, score: 0.0)
        FactoryGirl.create(:statement_argument_link, :pro, statement: statement, argument: argument)
        expect(Statement::Scoring.calculate_score(statement)).to eq nil
      end
    end

    context "when both, votes and arguments exist" do
      it "returns some number" do
        43.times { FactoryGirl.create(:vote, :up, statement: statement) }
        12.times { FactoryGirl.create(:vote, :down, statement: statement) }

        argument = FactoryGirl.create(:statement, score: 0.8)
        FactoryGirl.create(:statement_argument_link, :pro, statement: statement, argument: argument)

        argument = FactoryGirl.create(:statement, score: 0.5)
        FactoryGirl.create(:statement_argument_link, :pro, statement: statement, argument: argument)

        argument = FactoryGirl.create(:statement, score: 0.9)
        FactoryGirl.create(:statement_argument_link, :contra, statement: statement, argument: argument)

        expect(Statement::Scoring.calculate_score(statement)).to eq 0.5884684682399424
      end
    end
  end

  describe "#self.update_scores" do
    context "when no statements exist" do
      it "doesn't throw an error" do
        expect(Statement::Scoring.update_scores()).to eq true
      end
    end

    context "when one statements exist" do
      let!(:statement) { FactoryGirl.create(:statement) }
      let!(:vote) { FactoryGirl.create(:vote, :up, statement: statement) } # one vote should be enough for the score not to be nil

      before { Statement::Scoring.update_scores() }

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
        FactoryGirl.create_list(:vote, 12, :up, statement: a)
      end

      it "should fill in the score for all statements if sufficient information is available" do
        # First, make sure no score is assigned by now
        expect(Statement.where.not(score: nil).count) == 0

        Statement::Scoring.update_scores()

        # Expect a score for every but one statement
        expect(Statement.where.not(score: nil).count).to eq Statement.count - 1

        # Expect that the only statement without score is s_5
        expect(Statement.find_by(score: nil)).to eq s_5
      end
    end
  end
end
