require 'rails_helper'

RSpec.describe ArgumentalQuestioningLink, type: :model do
  # Using factory girl to build the link between the two questionings.
  # That way it is ensured, that factory girl returns a valid link object.
  before { @link = FactoryGirl.build(:argumental_questioning_link) }

  subject { @link }

  # Test that the link is valid at this point. Otherwise
  # the tests below lose integrity because the object might be
  # invalid for the wrong reason.
  it { should be_valid }

  # Test the implemented model validations.
  describe "validations" do
    describe "when is_pro_argument" do
      context "is nil" do
        before { @link.is_pro_argument = nil }
        it { should_not be_valid }
      end
    end

    describe "when questioning" do
      context "is not associated" do
        before { @link.questioning = nil }
        it { should_not be_valid }
      end
    end

    describe "when argument" do
      context "is not associated" do
        before { @link.argument = nil }
        it { should_not be_valid }
      end
    end
  end
end
