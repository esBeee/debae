require 'rails_helper'

RSpec.describe StatementArgumentLink, type: :model do
  # Using factory girl to build the link between the two statements.
  # That way it is ensured, that factory girl returns a valid link object.
  before { @link = FactoryGirl.build(:statement_argument_link) }

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
          FactoryGirl.create(:statement_argument_link, statement: @link.statement, argument: @link.argument)
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

    describe "when statement is already declared as argument for the argument (2-statement-loop)" do
      before { FactoryGirl.create(:statement_argument_link, statement: @link.argument, argument: @link.statement) }

      it "is not valid" do
        expect(@link).not_to be_valid
      end

      it "adds an error message" do
        @link.valid?
        expect(@link.errors.full_messages).to eq ["Statement " +
          I18n.t("activerecord.errors.messages.statement_is_argument_for_argument")]
      end
    end
  end

  # Test that the utilities for the associated objects are defined.
  describe "association utilities" do
    # Test that the pro_votes getter is defined correctly.
    describe "#pro_votes" do
      let!(:pro_vote) do
        FactoryGirl.create(:vote, :up, voteable: @link)
      end
      let!(:contra_vote) do
        FactoryGirl.create(:vote, :down, voteable: @link)
      end

      it "returns all pro votes" do
        # Test that the getter delivers the pro vote.
        expect(@link.pro_votes).to include pro_vote

        # Make sure only this one vote was delivered. (Implies that
        # the contra vote wasn't)
        expect(@link.pro_votes.size).to eq 1
      end
    end

    # Test that the contra_votes getter is defined correctly.
    describe "#contra_votes" do
      let!(:pro_vote) do
        FactoryGirl.create(:vote, :up, voteable: @link)
      end
      let!(:contra_vote) do
        FactoryGirl.create(:vote, :down, voteable: @link)
      end

      it "returns all contra votes" do
        # Test that the getter delivers the contra vote.
        expect(@link.contra_votes).to include contra_vote

        # Make sure only this one vote was delivered. (Implies that
        # the pro vote wasn't)
        expect(@link.contra_votes.size).to eq 1
      end
    end
  end

  describe "callbacks" do
    describe "on create" do
      describe "new-argument-email", mailer_helpers: true do
        let(:statement) { FactoryGirl.create(:statement) }
        let(:argument) { FactoryGirl.create(:statement) }
        let(:link) { FactoryGirl.build(:statement_argument_link, statement: statement, argument: argument) }
        let(:receiver) { statement.user }

        before do
          # Make sure the receiver's setting allow to send an email by default.
          receiver.email_if_new_argument = true
          receiver.save!
        end

        it "sends an email to the creator of the backed statement" do
          link.save!
          expect(only_email_to).to eq [receiver.email]
        end

        it "doesn't send an email if the creator of the backed statement doesn't want one" do
          # Set the user's settings so he doesn't want an email.
          receiver.email_if_new_argument = false
          receiver.save!

          link.save!
          expect(deliveries.count).to eq 0
        end

        it "doesn't send an email if the creator of the argument equals the creator of the statement" do
          # Make sure the argument belongs to the user of the statement
          argument.user_id = statement.user_id
          argument.save!

          link.save!
          expect(deliveries.count).to eq 0
        end

        it "doesn't send an email on update" do
          link.save!

          # Reset emails
          reset_email

          # Update the link
          link.created_at = Time.now
          link.save!

          expect(deliveries.count).to eq 0
        end
      end
    end
  end

  describe "#ordered_by_score" do
    let(:link1) { FactoryGirl.create(:statement_argument_link, score: 0.7) }
    let(:link2) { FactoryGirl.create(:statement_argument_link, score: 0.9) }
    let(:link3) { FactoryGirl.create(:statement_argument_link, score: 0) }
    let(:link4) { FactoryGirl.create(:statement_argument_link, score: nil) }

    let(:links) { described_class.where(id: [link1.id, link2.id, link3.id, link4.id]) }

    it "returns the links ordered by voting score" do
      expect(links.ordered_by_score.to_a).to eq(
        [link2, link1, link4, link3]
      )
    end
  end
end
