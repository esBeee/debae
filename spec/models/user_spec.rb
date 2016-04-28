require 'rails_helper'

RSpec.describe User, type: :model do
  # Using factory girl to build a user. That way it is ensured,
  # that factory girl returns a valid user object.
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  # Test that the user is valid at this point. Otherwise
  # the tests below lose integrity because the object might be
  # invalid for the wrong reason.
  it { should be_valid }

  # Test the implemented model validations.
  describe "validations" do
    context "when password is too short (7 characters)" do
      before { @user.password = "1234567" }
      it { should_not be_valid }
    end

    context "when password has min length (8 characters)" do
      before { @user.password = "12345678" }
      it { should be_valid }
    end

    # Create a couple of tests with invalid email addresses.
    %w(a@b @b.de a@.de ab.de a a@b. a.b.c).each do |invalid_email|
      context "when email is #{invalid_email} (invalid)" do
        before { @user.email = invalid_email }
        it { should_not be_valid }
      end
    end

    # Create a couple of tests with valid email addresses.
    %w(a@b.de aaaaa@bbbbbb.des a@b.d a@b.accountant).each do |valid_email|
      context "when email is #{valid_email} (valid)" do
        before { @user.email = valid_email }
        it { should be_valid }
      end
    end

    describe "when name" do
      context "is blank" do
        before { @user.name = " " }
        it { should_not be_valid }
      end

      context "is too long (71 characters)" do
        before { @user.name = "a" * 71 }
        it { should_not be_valid }
      end

      context "is just short enough (70 characters)" do
        before { @user.name = "a" * 70 }
        it { should be_valid }
      end

      context "is too short (1 character)" do
        before { @user.name = "a" }
        it { should_not be_valid }
      end

      context "is just long enough (2 characters)" do
        before { @user.name = "a" * 2 }
        it { should be_valid }
      end
    end

    describe "when avatar_url" do
      context "is nil" do
        before { @user.avatar_url = nil }
        it { should be_valid }
      end

      context "is too long (1001 characters)" do
        before { @user.avatar_url = "a" * 1001 }
        it { should_not be_valid }
      end

      context "is just short enough (1000 characters)" do
        before { @user.avatar_url = "http://google.com/" + "a" * (1000 - 18) }
        it { should be_valid }
      end

      %w(htt://google.com ttp://google.com hp://google.com http//google.com 
        http:/google.com http:// http://google http:// google.).each do |invalid_url|
          context "is #{invalid_url} (an invalid url)" do
            before { @user.avatar_url = invalid_url }
            it { should_not be_valid }
          end
      end

      %w(http://google.com https://google.com https://de.amazon.sl/afinJN/jngkQjnjkgn/jnkfwf?locale=se 
        http://www.google.museum).each do |valid_url|
          context "is #{valid_url} (a valid url)" do
            before { @user.avatar_url = valid_url }
            it { should be_valid }
          end
      end
    end
  end

  # Test that the utilities for the associated objects are defined.
  describe "association utilities" do
    # Make sure there's a getter/setter for the user's statements.
    describe "#statements" do
      let(:statement) { FactoryGirl.build_stubbed(:statement) }

      it "returns all associated statements" do
        # Add statement to the user's statements.
        # This implicitly tests the existence of a setter.
        @user.statements << statement

        # Now test that the getter delivers the statement.
        expect(@user.statements).to include(statement)

        # Make sure only this one link was delivered.
        expect(@user.statements.size).to eq 1
      end
    end

    # Make sure there's a getter/setter for the user's votes.
    describe "#votes" do
      let(:vote) { FactoryGirl.build_stubbed(:vote) }

      it "returns all associated statements" do
        # Add vote to the user's votes.
        # This implicitly tests the existence of a setter.
        @user.votes << vote

        # Now test that the getter delivers the vote.
        expect(@user.votes).to include(vote)

        # Make sure only this one vote was delivered.
        expect(@user.votes.size).to eq 1
      end
    end

    # Make sure there's a getter/setter for the user's comments.
    describe "#comments" do
      let(:comment) { FactoryGirl.build_stubbed(:comment) }

      it "returns all associated statements" do
        # Add comment to the user's comments.
        # This implicitly tests the existence of a setter.
        @user.comments << comment

        # Now test that the getter delivers the comment.
        expect(@user.comments).to include(comment)

        # Make sure only this one comment was delivered.
        expect(@user.comments.size).to eq 1
      end
    end
  end
end
