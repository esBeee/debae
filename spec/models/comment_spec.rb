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

      context "is too short (1 character)" do
        before { @comment.body = "A" }
        it { should_not be_valid }
      end

      context "is long enough (2 characters)" do
        before { @comment.body = "AA" }
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
end
