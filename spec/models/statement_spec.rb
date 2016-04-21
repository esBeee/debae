require 'rails_helper'

RSpec.describe Statement, type: :model do
  # Using factory girl to build a statement. That way it is ensured,
  # that factory girl returns a valid statement object.
  before { @statement = FactoryGirl.build(:statement) }

  subject { @statement }

  # Test that the statement is valid at this point. Otherwise
  # the tests below lose integrity because the object might be
  # invalid for the wrong reason.
  it { should be_valid }

  # Test the implemented model validations.
  describe "validations" do
    describe "when body" do
      context "is nil" do
        before { @statement.body = nil }
        it { should_not be_valid }
      end

      context "is blank" do
        before { @statement.body = " " }
        it { should_not be_valid }
      end

      context "is too short (1 character)" do
        before { @statement.body = "A" }
        it { should_not be_valid }
      end

      context "is long enough (2 characters)" do
        before { @statement.body = "AA" }
        it { should be_valid }
      end

      context "is too long (261 characters)" do
        before { @statement.body = "A" * 261 }
        it { should_not be_valid }
      end

      context "is just not too long (260 characters)" do
        before { @statement.body = "A" * 260 }
        it { should be_valid }
      end
    end

    describe "when user" do
      context "is not associated" do
        before { @statement.user = nil }
        it { should_not be_valid }
      end
    end
  end

  # Test that the utilities for the associated objects are defined.
  describe "association utilities" do
    # Make sure there's a getter for the statement's argumental_questioning_links.
    describe "#argumental_questioning_links" do
      let(:argumental_questioning_link) do
        FactoryGirl.build_stubbed(:argumental_questioning_link, statement: @statement)
      end

      it "returns all associated argumental statement links" do
        # Add argumental_questioning_link to the statement's argumental_questioning_links.
        # This implicitly tests the existence of a setter.
        @statement.argumental_questioning_links << argumental_questioning_link

        # Now test that the getter delivers the argumental_questioning_link.
        expect(@statement.argumental_questioning_links).to include argumental_questioning_link

        # Make sure only this one link was delivered.
        expect(@statement.argumental_questioning_links.size).to eq 1
      end
    end

    # Make sure there's a getter for the statement's arguments.
    describe "#arguments" do
      let(:argument) { FactoryGirl.create(:statement) }
      let!(:argumental_questioning_link) do
        FactoryGirl.create(:argumental_questioning_link, statement: @statement, argument: argument)
      end

      it "returns all associated arguments" do
        # Add argumental_questioning_link to the statement's argumental_questioning_links.
        @statement.argumental_questioning_links << argumental_questioning_link

        # Now test that the getter delivers the argument.
        expect(@statement.arguments).to include argument

        # Make sure only this one argument was delivered.
        expect(@statement.arguments.size).to eq 1
      end
    end

    # Test that the pro_arguments getter is defined correctly.
    describe "#pro_arguments" do
      let!(:pro_argument) do
        FactoryGirl.create(:argumental_questioning_link, is_pro_argument: true, statement: @statement).argument
      end
      let!(:contra_argument) do
        FactoryGirl.create(:argumental_questioning_link, is_pro_argument: false, statement: @statement).argument
      end

      it "returns all pro arguments" do
        # Test that the getter delivers the pro argument.
        expect(@statement.pro_arguments).to include pro_argument

        # Make sure only this one argument was delivered. (Implies that
        # the contra argument wasn't)
        expect(@statement.pro_arguments.size).to eq 1
      end
    end

    # Test that the contra_arguments getter is defined correctly.
    describe "#contra_arguments" do
      let!(:pro_argument) do
        FactoryGirl.create(:argumental_questioning_link, is_pro_argument: true, statement: @statement).argument
      end
      let!(:contra_argument) do
        FactoryGirl.create(:argumental_questioning_link, is_pro_argument: false, statement: @statement).argument
      end

      it "returns all contra arguments" do
        # Test that the getter delivers the contra argument.
        expect(@statement.contra_arguments).to include contra_argument

        # Make sure only this one argument was delivered. (Implies that
        # the pro argument wasn't)
        expect(@statement.contra_arguments.size).to eq 1
      end
    end

    # Test that the pro_votes getter is defined correctly.
    describe "#pro_votes" do
      let!(:pro_vote) do
        FactoryGirl.create(:vote, is_pro_vote: true, statement: @statement)
      end
      let!(:contra_vote) do
        FactoryGirl.create(:vote, is_pro_vote: false, statement: @statement)
      end

      it "returns all pro votes" do
        # Test that the getter delivers the pro vote.
        expect(@statement.pro_votes).to include pro_vote

        # Make sure only this one vote was delivered. (Implies that
        # the contra vote wasn't)
        expect(@statement.pro_votes.size).to eq 1
      end
    end

    # Test that the contra_votes getter is defined correctly.
    describe "#contra_votes" do
      let!(:pro_vote) do
        FactoryGirl.create(:vote, is_pro_vote: true, statement: @statement)
      end
      let!(:contra_vote) do
        FactoryGirl.create(:vote, is_pro_vote: false, statement: @statement)
      end

      it "returns all contra votes" do
        # Test that the getter delivers the contra vote.
        expect(@statement.contra_votes).to include contra_vote

        # Make sure only this one vote was delivered. (Implies that
        # the pro vote wasn't)
        expect(@statement.contra_votes.size).to eq 1
      end
    end
  end
end
