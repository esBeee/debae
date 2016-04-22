require 'rails_helper'

RSpec.describe VotesHelper, type: :helper do
  describe "#has_voted?" do
    let(:user) { vote.user }
    let(:statement) { vote.statement }

    context "when user has voted a statement up" do
      let(:vote) { FactoryGirl.create(:vote, :up) }

      context "and the function is called with true as first argument" do
        it "returns the vote (the user has up-voted the statement)" do
          expect(helper.has_voted?(true, user, statement)).to eq vote
        end
      end

      context "and the function is called with false as first argument" do
        it "returns nil (the user has not down-voted the statement)" do
          expect(helper.has_voted?(false, user, statement)).to eq nil
        end
      end
    end

    context "when user has voted a statement down" do
      let(:vote) { FactoryGirl.create(:vote, :down) }

      context "and the function is called with true as first argument" do
        it "returns nil (the user has not up-voted the statement)" do
          expect(helper.has_voted?(true, user, statement)).to eq nil
        end
      end

      context "and the function is called with false as first argument" do
        it "returns vote (the user has down-voted the statement)" do
          expect(helper.has_voted?(false, user, statement)).to eq vote
        end
      end
    end

    context "when user hasn't voted at all for this statement" do
      let(:user) { FactoryGirl.create(:user) }
      let(:statement) { FactoryGirl.create(:statement) }

      context "and the function is called with true as first argument" do
        it "returns nil (the user has not up-voted the statement)" do
          expect(helper.has_voted?(true, user, statement)).to eq nil
        end
      end

      context "and the function is called with false as first argument" do
        it "returns nil (the user has not down-voted the statement)" do
          expect(helper.has_voted?(false, user, statement)).to eq nil
        end
      end
    end
  end
end
