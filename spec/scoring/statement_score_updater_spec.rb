require 'rails_helper'

RSpec.describe StatementScoreUpdater, type: :model do
  let(:updater) { described_class.new(statement.id) }
  let(:statement) { FactoryGirl.create(:statement, score: nil) }

  describe '#update' do
    subject(:update) { updater.update }

    describe 'vote score' do
      context 'when the statement has no votes yet' do
        it 'updates the statement\'s score to nil' do
          update
          expect(statement.reload.score).to eq(nil)
        end

        it 'updates the statement\'s argument_score to nil' do
          update
          expect(statement.reload.argument_score).to eq(nil)
        end

        it 'updates the statement\'s vote_score to nil' do
          update
          expect(statement.reload.vote_score).to eq(nil)
        end

        it 'updates the statement\'s amount_of_votes to 0' do
          update
          expect(statement.reload.amount_of_votes).to eq(0)
        end
      end

      context 'when the statement has only a up-vote yet' do
        let!(:vote1) { FactoryGirl.create(:vote, :up, voteable: statement) }

        it 'updates the statement\'s score to 1' do
          update
          expect(statement.reload.score).to eq(1)
        end

        it 'updates the statement\'s argument_score to nil' do
          update
          expect(statement.reload.argument_score).to eq(nil)
        end

        it 'updates the statement\'s vote_score to 1' do
          update
          expect(statement.reload.vote_score).to eq(1)
        end

        it 'updates the statement\'s amount_of_votes to 1' do
          update
          expect(statement.reload.amount_of_votes).to eq(1)
        end
      end

      context 'when the statement has only a down-vote yet' do
        let!(:vote1) { FactoryGirl.create(:vote, :down, voteable: statement) }

        it 'updates the statement\'s score to 0' do
          update
          expect(statement.reload.score).to eq(0)
        end

        it 'updates the statement\'s argument_score to nil' do
          update
          expect(statement.reload.argument_score).to eq(nil)
        end

        it 'updates the statement\'s vote_score to 0' do
          update
          expect(statement.reload.vote_score).to eq(0)
        end

        it 'updates the statement\'s amount_of_votes to 1' do
          update
          expect(statement.reload.amount_of_votes).to eq(1)
        end
      end

      context 'when the statement has several votes' do
        let!(:vote1) { FactoryGirl.create(:vote, :up, voteable: statement) }
        let!(:vote2) { FactoryGirl.create(:vote, :up, voteable: statement) }
        let!(:vote3) { FactoryGirl.create(:vote, :up, voteable: statement) }
        let!(:vote4) { FactoryGirl.create(:vote, :down, voteable: statement) }

        it 'updates the statement\'s score to 0.75' do
          update
          expect(statement.reload.score).to eq(0.75)
        end

        it 'updates the statement\'s argument_score to nil' do
          update
          expect(statement.reload.argument_score).to eq(nil)
        end

        it 'updates the statement\'s vote_score to 0.75' do
          update
          expect(statement.reload.vote_score).to eq(0.75)
        end

        it 'updates the statement\'s amount_of_votes to 4' do
          update
          expect(statement.reload.amount_of_votes).to eq(4)
        end
      end
    end

    describe 'argument score' do
      context 'when the statement has no arguments yet' do
        it 'updates the statement\'s score to nil' do
          update
          expect(statement.reload.score).to eq(nil)
        end

        it 'updates the statement\'s argument_score to nil' do
          update
          expect(statement.reload.argument_score).to eq(nil)
        end

        it 'updates the statement\'s vote_score to nil' do
          update
          expect(statement.reload.vote_score).to eq(nil)
        end
      end

      context 'when the statement has 1 pro-argument without votes and score' do
        let!(:link1) { FactoryGirl.create(:statement_argument_link, :pro, statement: statement, argument: argument1A) }
        let!(:argument1A) { FactoryGirl.create(:statement, score: nil) }

        it 'updates the statement\'s score to 0.5' do
          update
          expect(statement.reload.score).to eq(0.5)
        end

        it 'updates the statement\'s argument_score to 0.5' do
          update
          expect(statement.reload.argument_score).to eq(0.5)
        end

        it 'updates the statement\'s vote_score to nil' do
          update
          expect(statement.reload.vote_score).to eq(nil)
        end

        it 'updates the 1st link\'s score to nil' do
          update
          expect(link1.reload.score).to eq(nil)
        end
      end

      context 'when the statement has 1 scored but down-voted pro-argument' do
        let!(:link1) { FactoryGirl.create(:statement_argument_link, :pro, statement: statement, argument: argument1A) }
        let!(:argument1A) { FactoryGirl.create(:statement, score: 1.0) }
        let!(:vote1A) { FactoryGirl.create(:vote, :up, voteable: link1) }
        let!(:vote1B) { FactoryGirl.create(:vote, :down, voteable: link1) }
        let!(:vote1C) { FactoryGirl.create(:vote, :down, voteable: link1) }
        let!(:vote1C) { FactoryGirl.create(:vote, :down, voteable: link1) }

        it 'updates the statement\'s score to 0.5' do
          update
          expect(statement.reload.score).to eq(0.5)
        end

        it 'updates the statement\'s argument_score to 0.5' do
          update
          expect(statement.reload.argument_score).to eq(0.5)
        end

        it 'updates the statement\'s vote_score to nil' do
          update
          expect(statement.reload.vote_score).to eq(nil)
        end

        it 'updates the 1st link\'s score to 0' do
          update
          expect(link1.reload.score).to eq(0)
        end
      end

      context 'when the statement has 1 contra-argument with votes but no score' do
        let!(:link1) { FactoryGirl.create(:statement_argument_link, :contra, statement: statement, argument: argument1A) }
        let!(:argument1A) { FactoryGirl.create(:statement, score: nil) }
        let!(:vote1A) { FactoryGirl.create(:vote, :up, voteable: link1) }
        let!(:vote1B) { FactoryGirl.create(:vote, :up, voteable: link1) }
        let!(:vote1C) { FactoryGirl.create(:vote, :down, voteable: link1) }

        it 'updates the statement\'s score to 0.5' do
          update
          expect(statement.reload.score).to eq(0.5)
        end

        it 'updates the statement\'s argument_score to 0.5' do
          update
          expect(statement.reload.argument_score).to eq(0.5)
        end

        it 'updates the statement\'s vote_score to nil' do
          update
          expect(statement.reload.vote_score).to eq(nil)
        end

        it 'updates the 1st link\'s score to nil' do
          update
          expect(link1.reload.score).to eq(nil)
        end
      end

      context 'when the statement has 1 contra-argument with a score of 0.789 and no votes' do
        let!(:link1) { FactoryGirl.create(:statement_argument_link, :contra, statement: statement, argument: argument1A) }
        let!(:argument1A) { FactoryGirl.create(:statement, score: 0.789) }

        it 'updates the statement\'s score to 0.1055' do
          update
          expect(statement.reload.score).to eq(0.1055)
        end

        it 'updates the statement\'s argument_score to 0.1055' do
          update
          expect(statement.reload.argument_score).to eq(0.1055)
        end

        it 'updates the statement\'s vote_score to nil' do
          update
          expect(statement.reload.vote_score).to eq(nil)
        end

        it 'updates the 1st link\'s score to 0.789' do
          update
          expect(link1.reload.score).to eq(0.789)
        end
      end

      context 'when the statement has 1 pro-argument with a score of 0.789 and it is up-voted' do
        let!(:link1) { FactoryGirl.create(:statement_argument_link, :pro, statement: statement, argument: argument1A) }
        let!(:argument1A) { FactoryGirl.create(:statement, score: 0.789) }
        let!(:vote1A) { FactoryGirl.create(:vote, :up, voteable: link1) }

        it 'updates the statement\'s score to 0.8945' do
          update
          expect(statement.reload.score).to eq(0.8945)
        end

        it 'updates the statement\'s argument_score to 0.8945' do
          update
          expect(statement.reload.argument_score).to eq(0.8945)
        end

        it 'updates the statement\'s vote_score to nil' do
          update
          expect(statement.reload.vote_score).to eq(nil)
        end

        it 'updates the 1st link\'s score to 0.789' do
          update
          expect(link1.reload.score).to eq(0.789)
        end
      end

      context 'when the statement has 1 pro-argument with a score of 1.0 and it is down-voted' do
        let!(:link1) { FactoryGirl.create(:statement_argument_link, :pro, statement: statement, argument: argument1A) }
        let!(:argument1A) { FactoryGirl.create(:statement, score: 1.0) }
        let!(:vote1A) { FactoryGirl.create(:vote, :up, voteable: link1) }
        let!(:vote1B) { FactoryGirl.create(:vote, :down, voteable: link1) }
        let!(:vote1C) { FactoryGirl.create(:vote, :down, voteable: link1) }

        it 'updates the statement\'s score to 0.5' do
          update
          expect(statement.reload.score).to eq(0.5)
        end

        it 'updates the statement\'s argument_score to 0.5' do
          update
          expect(statement.reload.argument_score).to eq(0.5)
        end

        it 'updates the statement\'s vote_score to nil' do
          update
          expect(statement.reload.vote_score).to eq(nil)
        end

        it 'updates the 1st link\'s score to 0.0' do
          update
          expect(link1.reload.score).to eq(0.0)
        end
      end

      context 'when the statement has 1 pro-argument and 1 contra-argument ' \
              'and both have an identical scoring and voting' do
        let!(:link1) { FactoryGirl.create(:statement_argument_link, :pro, statement: statement, argument: argument1A) }
        let!(:argument1A) { FactoryGirl.create(:statement, score: 0.8) }
        let!(:vote1A) { FactoryGirl.create(:vote, :up, voteable: link1) }
        let!(:vote1B) { FactoryGirl.create(:vote, :down, voteable: link1) }

        let!(:link2) { FactoryGirl.create(:statement_argument_link, :contra, statement: statement, argument: argument2A) }
        let!(:argument2A) { FactoryGirl.create(:statement, score: 0.8) }
        let!(:vote2A) { FactoryGirl.create(:vote, :up, voteable: link2) }
        let!(:vote2B) { FactoryGirl.create(:vote, :down, voteable: link2) }

        it 'updates the statement\'s score to 0.5' do
          update
          expect(statement.reload.score).to eq(0.5)
        end

        it 'updates the statement\'s argument_score to 0.5' do
          update
          expect(statement.reload.argument_score).to eq(0.5)
        end

        it 'updates the statement\'s vote_score to nil' do
          update
          expect(statement.reload.vote_score).to eq(nil)
        end

        it 'updates the 1st link\'s score to 0.8' do
          update
          expect(link1.reload.score).to eq(0.8)
        end

        it 'updates the 2nd link\'s score to 0.8' do
          update
          expect(link2.reload.score).to eq(0.8)
        end
      end

      context 'when the statement has 1 pro-argument and 1 contra-argument, ' \
              'while the pro argument scores slightly better' do
        let!(:link1) { FactoryGirl.create(:statement_argument_link, :pro, statement: statement, argument: argument1A) }
        let!(:argument1A) { FactoryGirl.create(:statement, score: 0.8) }
        let!(:vote1A) { FactoryGirl.create(:vote, :up, voteable: link1) }
        let!(:vote1B) { FactoryGirl.create(:vote, :down, voteable: link1) }

        let!(:link2) { FactoryGirl.create(:statement_argument_link, :contra, statement: statement, argument: argument2A) }
        let!(:argument2A) { FactoryGirl.create(:statement, score: 0.7) }
        let!(:vote2A) { FactoryGirl.create(:vote, :up, voteable: link2) }
        let!(:vote2B) { FactoryGirl.create(:vote, :down, voteable: link2) }

        it 'updates the statement\'s score to 0.533333333333333' do
          update
          expect(statement.reload.score).to eq(0.533333333333333)
        end

        it 'updates the statement\'s argument_score to 0.533333333333333' do
          update
          expect(statement.reload.argument_score).to eq(0.533333333333333)
        end

        it 'updates the statement\'s vote_score to nil' do
          update
          expect(statement.reload.vote_score).to eq(nil)
        end

        it 'updates the 1st link\'s score to 0.8' do
          update
          expect(link1.reload.score).to eq(0.8)
        end

        it 'updates the 2nd link\'s score to 0.7' do
          update
          expect(link2.reload.score).to eq(0.7)
        end
      end

      context 'when the statement has 1 pro-argument and 1 contra-argument, ' \
              'while the pro argument has more up-votes' do
        let!(:link1) { FactoryGirl.create(:statement_argument_link, :pro, statement: statement, argument: argument1A) }
        let!(:argument1A) { FactoryGirl.create(:statement, score: 0.8) }
        let!(:vote1A) { FactoryGirl.create(:vote, :up, voteable: link1) }
        let!(:vote1B) { FactoryGirl.create(:vote, :up, voteable: link1) }
        let!(:vote1C) { FactoryGirl.create(:vote, :down, voteable: link1) }

        let!(:link2) { FactoryGirl.create(:statement_argument_link, :contra, statement: statement, argument: argument2A) }
        let!(:argument2A) { FactoryGirl.create(:statement, score: 0.8) }
        let!(:vote2A) { FactoryGirl.create(:vote, :up, voteable: link2) }
        let!(:vote2B) { FactoryGirl.create(:vote, :down, voteable: link2) }

        it 'updates the statement\'s score to 0.666666666666667' do
          update
          expect(statement.reload.score).to eq(0.666666666666667)
        end

        it 'updates the statement\'s argument_score to 0.666666666666667' do
          update
          expect(statement.reload.argument_score).to eq(0.666666666666667)
        end

        it 'updates the statement\'s vote_score to nil' do
          update
          expect(statement.reload.vote_score).to eq(nil)
        end

        it 'updates the 1st link\'s score to 0.8' do
          update
          expect(link1.reload.score).to eq(0.8)
        end

        it 'updates the 2nd link\'s score to 0.4' do
          update
          expect(link2.reload.score).to eq(0.4)
        end
      end

      context 'when the statement has 1 pro-argument and 1 contra-argument, ' \
              'while the pro argument scores slightly better but the contra ' \
              'argument has way more up-votes' do
        let!(:link1) { FactoryGirl.create(:statement_argument_link, :pro, statement: statement, argument: argument1A) }
        let!(:argument1A) { FactoryGirl.create(:statement, score: 0.8) }
        let!(:vote1A) { FactoryGirl.create(:vote, :up, voteable: link1) }
        let!(:vote1B) { FactoryGirl.create(:vote, :down, voteable: link1) }

        let!(:link2) { FactoryGirl.create(:statement_argument_link, :contra, statement: statement, argument: argument2A) }
        let!(:argument2A) { FactoryGirl.create(:statement, score: 0.7) }
        let!(:vote2A) { FactoryGirl.create(:vote, :up, voteable: link2) }
        let!(:vote2B) { FactoryGirl.create(:vote, :up, voteable: link2) }
        let!(:vote2C) { FactoryGirl.create(:vote, :up, voteable: link2) }
        let!(:vote2D) { FactoryGirl.create(:vote, :up, voteable: link2) }
        let!(:vote2E) { FactoryGirl.create(:vote, :down, voteable: link2) }

        it 'updates the statement\'s score to 0.25' do
          update
          expect(statement.reload.score).to eq(0.25)
        end

        it 'updates the statement\'s argument_score to 0.25' do
          update
          expect(statement.reload.argument_score).to eq(0.25)
        end

        it 'updates the statement\'s vote_score to nil' do
          update
          expect(statement.reload.vote_score).to eq(nil)
        end

        it 'updates the 1st link\'s score to 0.2' do
          update
          expect(link1.reload.score).to eq(0.2)
        end

        it 'updates the 2nd link\'s score to 0.7' do
          update
          expect(link2.reload.score).to eq(0.7)
        end
      end

      context 'when the statement has 1 pro-argument and 2 contra-argument, ' \
              'while the two contra argument weight the same as the pro ' \
              'argument' do
        let!(:link1) { FactoryGirl.create(:statement_argument_link, :pro, statement: statement, argument: argument1A) }
        let!(:argument1A) { FactoryGirl.create(:statement, score: 0.8) }
        let!(:vote1A) { FactoryGirl.create(:vote, :up, voteable: link1) }
        let!(:vote1B) { FactoryGirl.create(:vote, :down, voteable: link1) }

        let!(:link2) { FactoryGirl.create(:statement_argument_link, :contra, statement: statement, argument: argument2A) }
        let!(:argument2A) { FactoryGirl.create(:statement, score: 0.4) }
        let!(:vote2A) { FactoryGirl.create(:vote, :up, voteable: link2) }
        let!(:vote2B) { FactoryGirl.create(:vote, :down, voteable: link2) }

        let!(:link3) { FactoryGirl.create(:statement_argument_link, :contra, statement: statement, argument: argument3A) }
        let!(:argument3A) { FactoryGirl.create(:statement, score: 0.4) }
        let!(:vote3A) { FactoryGirl.create(:vote, :up, voteable: link3) }
        let!(:vote3B) { FactoryGirl.create(:vote, :down, voteable: link3) }

        it 'updates the statement\'s score to 0.5' do
          update
          expect(statement.reload.score).to eq(0.5)
        end

        it 'updates the statement\'s argument_score to 0.5' do
          update
          expect(statement.reload.argument_score).to eq(0.5)
        end

        it 'updates the statement\'s vote_score to nil' do
          update
          expect(statement.reload.vote_score).to eq(nil)
        end

        it 'updates the 1st link\'s score to 0.8' do
          update
          expect(link1.reload.score).to eq(0.8)
        end

        it 'updates the 2nd link\'s score to 0.4' do
          update
          expect(link2.reload.score).to eq(0.4)
        end

        it 'updates the 3rd link\'s score to 0.4' do
          update
          expect(link2.reload.score).to eq(0.4)
        end
      end
    end

    describe 'vote and argument scores mixed' do
      context 'when the statement has a great vote score and a mediocre ' \
              'argument score' do
        let!(:vote1) { FactoryGirl.create(:vote, :up, voteable: statement) }
        let!(:vote2) { FactoryGirl.create(:vote, :up, voteable: statement) }
        let!(:vote3) { FactoryGirl.create(:vote, :up, voteable: statement) }
        let!(:vote4) { FactoryGirl.create(:vote, :up, voteable: statement) }
        let!(:vote5) { FactoryGirl.create(:vote, :down, voteable: statement) }

        let!(:link1) { FactoryGirl.create(:statement_argument_link, :pro, statement: statement, argument: argument1A) }
        let!(:argument1A) { FactoryGirl.create(:statement, score: 0.8) }
        let!(:vote1A) { FactoryGirl.create(:vote, :up, voteable: link1) }
        let!(:vote1B) { FactoryGirl.create(:vote, :down, voteable: link1) }

        let!(:link2) { FactoryGirl.create(:statement_argument_link, :contra, statement: statement, argument: argument2A) }
        let!(:argument2A) { FactoryGirl.create(:statement, score: 0.7) }
        let!(:vote2A) { FactoryGirl.create(:vote, :up, voteable: link2) }
        let!(:vote2B) { FactoryGirl.create(:vote, :down, voteable: link2) }

        it 'updates the statement\'s score to 0.666666666666667' do
          update
          expect(statement.reload.score).to eq(0.666666666666667)
        end

        it 'updates the statement\'s argument_score to 0.533333333333333' do
          update
          expect(statement.reload.argument_score).to eq(0.533333333333333)
        end

        it 'updates the statement\'s vote_score to 0.8' do
          update
          expect(statement.reload.vote_score).to eq(0.8)
        end

        it 'updates the statement\'s amount_of_votes to 5' do
          update
          expect(statement.reload.amount_of_votes).to eq(5)
        end

        it 'updates the 1st link\'s score to 0.8' do
          update
          expect(link1.reload.score).to eq(0.8)
        end

        it 'updates the 2nd link\'s score to 0.7' do
          update
          expect(link2.reload.score).to eq(0.7)
        end
      end
    end
  end
end
