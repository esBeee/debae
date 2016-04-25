require 'rails_helper'

RSpec.describe Comment, type: :model do
  
  before { @comment = FactoryGirl.build(:comment) }

  subject { @comment }

  it { should be_valid }

  # Test the implemented model validations.
  describe "validations" do
    describe "when body" do
      context "is nil" do
        before { @comment.body = nil }
        it { should_not be_valid }
      end

      context "is blank" do
        before { @comment.body = " " }
        it { should_not be_valid }
      end

      context "is just long enough (1 character)" do
        before { @comment.body = "A" }
        it { should be_valid }
      end

      context "is too long (10000 characters)" do
        before { @comment.body = "A" * 10000 }
        it { should_not be_valid }
      end

      context "is just not too long (9999 characters)" do
        before { @comment.body = "A" * 9999 }
        it { should be_valid }
      end
    end

    describe "when user" do
      context "is not associated" do
        before { @comment.user = nil }
        it { should_not be_valid }
      end
    end

    describe "when commentable" do
      context "is not associated" do
        before { @comment.commentable = nil }
        it { should_not be_valid }
      end
    end
  end

  # Test that the expected scopes exist. A scope in this context
  # can also be a regular method whose task it is, to
  # deliver a subset of comments.
  describe "scopes" do
    # Orders the collection by newest
    describe "#newest" do
      let!(:statement) { FactoryGirl.create(:statement) }
      let!(:newest_comment) { FactoryGirl.create(:comment, commentable: statement) }
      let!(:oldest_comment) { FactoryGirl.create(:comment, commentable: statement, created_at: Time.now - 3.days) }
      let!(:middle_old_comment) { FactoryGirl.create(:comment, commentable: statement, created_at: Time.now - 1.day) }

      it "returns all of the statement's comments ordered by newest first" do
        expect(statement.comments.newest[0]).to eq newest_comment
        expect(statement.comments.newest[1]).to eq middle_old_comment
      end
    end
  end
end
