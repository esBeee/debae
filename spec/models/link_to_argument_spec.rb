require 'rails_helper'

RSpec.describe LinkToArgument, type: :model do
  # Using factory girl to build the link between the two statements.
  # That way it is ensured, that factory girl returns a valid link object.
  before { @link = FactoryGirl.build(:link_to_argument) }

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

    describe "when statement" do
      context "is not associated" do
        before { @link.statement = nil }
        it { should_not be_valid }
      end
    end

    describe "when argument" do
      context "is not associated" do
        before { @link.argument = nil }
        it { should_not be_valid }
      end
    end

    describe "when a statement-argument-pair" do
      context "already exists" do
        before do
          FactoryGirl.create(:link_to_argument, statement: @link.statement, argument: @link.argument)
        end
        it { should_not be_valid }
      end
    end

    describe "when a statement equals its argument" do
      before { @link.argument = @link.statement }

      it { should_not be_valid }

      it "should generate a translated error message" do
        @link.valid? # #valid? generates error messages if errors exist
        expect(@link.errors.full_messages.first).to include(I18n.t("activerecord.errors.messages.statement_eq_argument"))
      end
    end
  end
end
