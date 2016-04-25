require 'rails_helper'

RSpec.describe Vote, type: :model do
  # Using factory girl to build a vote. That way it is ensured,
  # that factory girl returns a valid vote object.
  before { @vote = FactoryGirl.build(:vote) }

  subject { @vote }

  # Test that the vote object is valid at this point. Otherwise
  # the tests below lose integrity because the object might be
  # invalid for the wrong reason.
  it { should be_valid }

  # Test the implemented model validations.
  describe "validations" do
    describe "when is_pro_vote" do
      context "is nil" do
        before { @vote.is_pro_vote = nil }
        it { should_not be_valid }
      end
    end

    describe "when user" do
      context "is not associated" do
        before { @vote.user = nil }
        it { should_not be_valid }
      end
    end

    describe "when voteable" do
      context "is not associated" do
        before { @vote.voteable = nil }
        it { should_not be_valid }
      end
    end

    describe "when a voteable-user-pair" do
      context "already exists" do
        before do
          FactoryGirl.create(:vote, voteable: @vote.voteable, user: @vote.user)
        end
        it { should_not be_valid }
      end
    end
  end
end
