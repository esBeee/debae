require 'rails_helper'

RSpec.describe Questioning, type: :model do
  # Using factory girl to build a questioning. That way it is ensured,
  # that factory girl returns a valid questioning object.
  before { @questioning = FactoryGirl.build(:questioning) }

  subject { @questioning }

  # Test that the questioning is valid at this point. Otherwise
  # the tests below lose integrity because the object might be
  # invalid for the wrong reason.
  it { should be_valid }

  # Test the implemented model validations.
  describe "validations" do
    describe "when body" do
      context "is nil" do
        before { @questioning.body = nil }
        it { should_not be_valid }
      end

      context "is blank" do
        before { @questioning.body = " " }
        it { should_not be_valid }
      end

      context "is too short (1 character)" do
        before { @questioning.body = "A" }
        it { should_not be_valid }
      end

      context "is long enough (2 characters)" do
        before { @questioning.body = "AA" }
        it { should be_valid }
      end

      context "is too long (261 characters)" do
        before { @questioning.body = "A" * 261 }
        it { should_not be_valid }
      end

      context "is just not too long (260 characters)" do
        before { @questioning.body = "A" * 260 }
        it { should be_valid }
      end
    end

    describe "when user" do
      context "is not associated" do
        before { @questioning.user = nil }
        it { should_not be_valid }
      end
    end
  end
end
