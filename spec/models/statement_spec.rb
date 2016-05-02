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

    describe "when score" do
      context "is less than 0" do
        before { @statement.score = -0.000000000001 }
        it { should_not be_valid }
      end

      context "equals 0" do
        before { @statement.score = 0 }
        it { should be_valid }
      end

      context "is greater than 1" do
        before { @statement.score = 1.00000000001 }
        it { should_not be_valid }
      end

      context "equals 1" do
        before { @statement.score = 1 }
        it { should be_valid }
      end

      context "equals nil" do
        before { @statement.score = nil }
        it { should be_valid }
      end
    end
  end

  # Test that the utilities for the associated objects are defined.
  describe "association utilities" do
    # Make sure there's a getter for the statement's links_to_arguments.
    describe "#links_to_arguments" do
      let(:statement_argument_link) do
        FactoryGirl.build_stubbed(:statement_argument_link, statement: @statement)
      end

      it "returns all associated links to arguments" do
        # Add statement_argument_link to the statement's links_to_arguments.
        # This implicitly tests the existence of a setter.
        @statement.links_to_arguments << statement_argument_link

        # Now test that the getter delivers the statement_argument_link.
        expect(@statement.links_to_arguments).to include statement_argument_link

        # Make sure only this one link was delivered.
        expect(@statement.links_to_arguments.size).to eq 1
      end
    end

    # Make sure there's a getter for the statement's arguments.
    describe "#arguments" do
      let(:argument) { FactoryGirl.create(:statement) }
      let!(:statement_argument_link) do
        FactoryGirl.create(:statement_argument_link, statement: @statement, argument: argument)
      end

      it "returns all associated arguments" do
        # Add statement_argument_link to the statement's links_to_arguments.
        @statement.links_to_arguments << statement_argument_link

        # Now test that the getter delivers the argument.
        expect(@statement.arguments).to include argument

        # Make sure only this one argument was delivered.
        expect(@statement.arguments.size).to eq 1
      end
    end

    # Test that the pro_arguments getter is defined correctly.
    describe "#pro_arguments" do
      let!(:pro_argument) do
        FactoryGirl.create(:statement_argument_link, is_pro_argument: true, statement: @statement).argument
      end
      let!(:contra_argument) do
        FactoryGirl.create(:statement_argument_link, is_pro_argument: false, statement: @statement).argument
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
        FactoryGirl.create(:statement_argument_link, is_pro_argument: true, statement: @statement).argument
      end
      let!(:contra_argument) do
        FactoryGirl.create(:statement_argument_link, is_pro_argument: false, statement: @statement).argument
      end

      it "returns all contra arguments" do
        # Test that the getter delivers the contra argument.
        expect(@statement.contra_arguments).to include contra_argument

        # Make sure only this one argument was delivered. (Implies that
        # the pro argument wasn't)
        expect(@statement.contra_arguments.size).to eq 1
      end
    end

    # Test that the votes getter is defined correctly.
    describe "#votes" do
      let!(:vote) do
        FactoryGirl.create(:vote, voteable: @statement)
      end
      let!(:a_foreign_vote) do
        FactoryGirl.create(:vote)
      end

      it "returns the statement's votes" do
        # Test that the getter delivers the vote.
        expect(@statement.votes).to include vote

        # Make sure only this one vote was delivered.
        expect(@statement.votes.size).to eq 1
      end
    end

    # Test that the pro_votes getter is defined correctly.
    describe "#pro_votes" do
      let!(:pro_vote) do
        FactoryGirl.create(:vote, :up, voteable: @statement)
      end
      let!(:contra_vote) do
        FactoryGirl.create(:vote, :down, voteable: @statement)
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
        FactoryGirl.create(:vote, :up, voteable: @statement)
      end
      let!(:contra_vote) do
        FactoryGirl.create(:vote, :down, voteable: @statement)
      end

      it "returns all contra votes" do
        # Test that the getter delivers the contra vote.
        expect(@statement.contra_votes).to include contra_vote

        # Make sure only this one vote was delivered. (Implies that
        # the pro vote wasn't)
        expect(@statement.contra_votes.size).to eq 1
      end
    end

    # #statements should return the statements this statement is an argument
    # for.
    describe "#statements" do
      let!(:statement) do
        FactoryGirl.create(:statement_argument_link, argument: @statement).statement
      end
      let!(:argument) do
        FactoryGirl.create(:statement_argument_link, statement: @statement).argument
      end

      it "returns all of the statement's votes" do
        # Test that the getter delivers the statement.
        expect(@statement.statements).to include statement

        # Make sure only this one statement was delivered.
        expect(@statement.statements.size).to eq 1
      end
    end

    # #comments should return the comments of this statement.
    describe "#comments" do
      let!(:foreign_comment) { FactoryGirl.create(:comment) } # Test that this comment is not delievered
      let(:comment) { FactoryGirl.build_stubbed(:comment) }

      it "returns all of the statement's comments" do
        # Add a comment to the statements comments. This implicitly
        # tests that a setter is available.
        @statement.comments << comment

        # Test that the getter delivers the statement.
        expect(@statement.comments).to include comment

        # Make sure only this one statement was delivered.
        expect(@statement.comments.size).to eq 1
      end
    end
  end

  # Test that the expected scopes exist. A scope in this context
  # can also be a regular method whose task it is, to
  # deliver a subset of statements.
  describe "scopes" do
    describe "#top_level" do
      it "doesn't include a statement that is an argument for another statement" do
        statement_is_argument = FactoryGirl.create(:statement_argument_link).argument
        expect(Statement.top_level).not_to include(statement_is_argument)
      end

      it "includes a statement that is not an argument for another statement" do
        statement_is_not_argument = FactoryGirl.create(:statement)
        expect(Statement.top_level).to include(statement_is_not_argument)
      end

      it "orders the statements - newest first" do
        oldest_statement = FactoryGirl.create(:statement, created_at: Time.now - 2.hour)
        newest_statement = FactoryGirl.create(:statement)
        middle_old_statement = FactoryGirl.create(:statement, created_at: Time.now - 1.hour)
        
        expect(Statement.top_level[0]).to eq(newest_statement)
        expect(Statement.top_level[1]).to eq(middle_old_statement)
        expect(Statement.top_level[2]).to eq(oldest_statement)
      end
    end

    describe "#ground_level" do
      let!(:ground_level_statement) { FactoryGirl.create(:statement) }
      let!(:top_level_statement) { FactoryGirl.create(:statement) }
      let!(:mid_level_statement) { FactoryGirl.create(:statement) }

      # Make sure that the statements defined above are really on the level
      # their name indicates.
      before do
        FactoryGirl.create(:statement_argument_link, statement: top_level_statement, argument: mid_level_statement)
        FactoryGirl.create(:statement_argument_link, statement: mid_level_statement, argument: ground_level_statement)
      end

      it "returns all ground-level-statements" do
        expect(Statement.ground_level).to include(ground_level_statement)

        # Make sure no other statement gets delivered
        expect(Statement.ground_level.count).to eq 1
      end
    end

    describe "#newest_comments" do
      let!(:statement) { FactoryGirl.create(:statement) }
      let!(:newest_comment) { FactoryGirl.create(:comment, commentable: statement) }
      let!(:oldest_comment) { FactoryGirl.create(:comment, commentable: statement, created_at: Time.now - 3.days) }
      let!(:middle_old_comment) { FactoryGirl.create(:comment, commentable: statement, created_at: Time.now - 1.day) }

      it "returns all of the statement's comments ordered by newest first" do
        expect(statement.newest_comments[0]).to eq newest_comment
        expect(statement.newest_comments[1]).to eq middle_old_comment
      end
    end
  end
end
