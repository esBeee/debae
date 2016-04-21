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

  # Test that the utilities for the associated objects are defined.
  describe "association utilities" do
    # Make sure there's a getter for the questioning's argumental_questioning_links.
    describe "#argumental_questioning_links" do
      let(:argumental_questioning_link) do
        FactoryGirl.build_stubbed(:argumental_questioning_link, questioning: @questioning)
      end

      it "returns all associated argumental questioning links" do
        # Add argumental_questioning_link to the questioning's argumental_questioning_links.
        # This implicitly tests the existence of a setter.
        @questioning.argumental_questioning_links << argumental_questioning_link

        # Now test that the getter delivers the argumental_questioning_link.
        expect(@questioning.argumental_questioning_links).to include argumental_questioning_link

        # Make sure only this one link was delivered.
        expect(@questioning.argumental_questioning_links.size).to eq 1
      end
    end

    # Make sure there's a getter for the questioning's arguments.
    describe "#arguments" do
      let(:argument) { FactoryGirl.create(:questioning) }
      let!(:argumental_questioning_link) do
        FactoryGirl.create(:argumental_questioning_link, questioning: @questioning, argument: argument)
      end

      it "returns all associated arguments" do
        # Add argumental_questioning_link to the questioning's argumental_questioning_links.
        @questioning.argumental_questioning_links << argumental_questioning_link

        # Now test that the getter delivers the argument.
        expect(@questioning.arguments).to include argument

        # Make sure only this one argument was delivered.
        expect(@questioning.arguments.size).to eq 1
      end
    end

    # Test that the pro_arguments getter is defined correctly.
    describe "#pro_arguments" do
      let!(:pro_argument) do
        FactoryGirl.create(:argumental_questioning_link, is_pro_argument: true, questioning: @questioning).argument
      end
      let!(:contra_argument) do
        FactoryGirl.create(:argumental_questioning_link, is_pro_argument: false, questioning: @questioning).argument
      end

      it "returns all pro arguments" do
        # Test that the scope delivers the pro argument.
        expect(@questioning.pro_arguments).to include pro_argument

        # Make sure only this one argument was delivered. (Implies that
        # the contra argument wasn't)
        expect(@questioning.pro_arguments.size).to eq 1
      end
    end

    # Test that the contra_arguments getter is defined correctly.
    describe "#contra_arguments" do
      let!(:pro_argument) do
        FactoryGirl.create(:argumental_questioning_link, is_pro_argument: true, questioning: @questioning).argument
      end
      let!(:contra_argument) do
        FactoryGirl.create(:argumental_questioning_link, is_pro_argument: false, questioning: @questioning).argument
      end

      it "returns all contra arguments" do
        # Test that the scope delivers the pro argument.
        expect(@questioning.contra_arguments).to include contra_argument

        # Make sure only this one argument was delivered. (Implies that
        # the pro argument wasn't)
        expect(@questioning.contra_arguments.size).to eq 1
      end
    end
  end
end
