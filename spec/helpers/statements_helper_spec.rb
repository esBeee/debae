require 'rails_helper'

RSpec.describe StatementsHelper, type: :helper do
  describe "#argument_hash" do
    let(:statement_to_support_id) { 3 }

    context "when called with both arguments nil" do
      it "returns nil" do
        expect(helper.argument_hash(nil, nil)).to eq nil
      end
    end

    context "when called with both arguments not nil" do
      it "returns nil" do
        expect(helper.argument_hash(1, 1)).to eq nil
      end
    end

    # When called with the frist argument, it is assumed that the first
    # argument can be interpreted as the id of the statement this
    # statement should support as a pro argument.
    context "when called with only the first argument" do
      it "returns a hash containing all necessary information" do
        expect(helper.argument_hash(statement_to_support_id, nil)).to eq ([statement_to_support_id, true])
      end
    end

    # When called with the second argument, it is assumed that the second
    # argument can be interpreted as the id of the statement this
    # statement should support as a contra argument.
    context "when called with only the second argument" do
      it "returns a hash containing all necessary information" do
        expect(helper.argument_hash(nil, statement_to_support_id)).to eq ([statement_to_support_id, false])
      end
    end
  end

  describe "#score" do
    context "when called with nil" do
      it "returns a not available string" do
        expect(helper.score(nil)).to eq I18n.t("statements.score.not_available")
      end
    end

    context "when called with a decimal" do
      it "returns a formatted score string with a rounded decimal" do
        expect(helper.score(0.223)).to eq "22 " + I18n.t("statements.score.unit")
      end
    end
  end

  describe "#creator_attitude" do
    context "when called with nil" do
      it "returns a blank string" do
        expect(helper.creator_attitude(nil)).to eq ""
      end
    end

    context "when called with a statement" do
      let(:statement) { FactoryGirl.create(:statement) }

      context "when the statement's creator was destroyed" do
        # before { statement.user.destroy }
        it "returns an appropriate code" do
          pending "A user can't be destroyed right now"
          expect(helper.creator_attitude(statement)).to eq "creator_destroyed"
        end
      end

      context "when the statement's creator exists" do
        let(:user) { statement.user }

        context "when the creator hasn't voted yet" do
          it "returns an appropriate code" do
            # Make sure a vote for another statement isn't interpreted here.
            FactoryGirl.create(:vote, user: user, voteable: FactoryGirl.create(:statement))

            expect(helper.creator_attitude(statement)).to eq "undecided"
          end
        end

        context "when the creator has voted pro" do
          before { FactoryGirl.create(:vote, :up, voteable: statement, user: user) }
          it "returns an appropriate code" do
            expect(helper.creator_attitude(statement)).to eq "agreeing"
          end
        end

        context "when the creator has voted pro" do
          before { FactoryGirl.create(:vote, :down, voteable: statement, user: user) }
          it "returns an appropriate code" do
            expect(helper.creator_attitude(statement)).to eq "disagreeing"
          end
        end
      end
    end
  end
end
