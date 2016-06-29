require 'rails_helper'

RSpec.describe StatementsHelper, type: :helper do
  describe "#argument_hash" do
    let(:statement_to_support_id) { 3 }

    context "when called with both arguments nil" do
      it "returns nil" do
        expect(helper.argument_hash(nil, nil)).to eq nil
      end
    end

    context "when called with both arguments not nil" do
      it "returns nil" do
        expect(helper.argument_hash(1, 1)).to eq nil
      end
    end

    # When called with the frist argument, it is assumed that the first
    # argument can be interpreted as the id of the statement this
    # statement should support as a pro argument.
    context "when called with only the first argument" do
      it "returns a hash containing all necessary information" do
        expect(helper.argument_hash(statement_to_support_id, nil)).to eq([statement_to_support_id, true])
      end
    end

    # When called with the second argument, it is assumed that the second
    # argument can be interpreted as the id of the statement this
    # statement should support as a contra argument.
    context "when called with only the second argument" do
      it "returns a hash containing all necessary information" do
        expect(helper.argument_hash(nil, statement_to_support_id)).to eq([statement_to_support_id, false])
      end
    end
  end

  describe "#score" do
    context "when called with nil" do
      it "returns a not available string" do
        expect(helper.score(nil)).to eq I18n.t("statements.score.not_available")
      end
    end

    context "when called with a decimal" do
      it "returns a formatted score string with a rounded decimal" do
        expect(helper.score(0.223)).to eq "22 " + I18n.t("statements.score.unit")
      end
    end
  end

  describe "#creator_attitude" do
    context "when called with nil" do
      it "returns a blank string" do
        expect(helper.creator_attitude(nil)).to eq ""
      end
    end

    context "when called with a statement" do
      let(:statement) { FactoryGirl.create(:statement) }

      context "when the statement's creator was destroyed" do
        # before { statement.user.destroy }
        it "returns an appropriate code" do
          pending "A user can't be destroyed right now"
          expect(helper.creator_attitude(statement)).to eq "creator_destroyed"
        end
      end

      context "when the statement's creator exists" do
        let(:user) { statement.user }

        context "when the creator hasn't voted yet" do
          it "returns an appropriate code" do
            # Make sure a vote for another statement isn't interpreted here.
            FactoryGirl.create(:vote, user: user, voteable: FactoryGirl.create(:statement))

            expect(helper.creator_attitude(statement)).to eq "undecided"
          end
        end

        context "when the creator has voted pro" do
          before { FactoryGirl.create(:vote, :up, voteable: statement, user: user) }
          it "returns an appropriate code" do
            expect(helper.creator_attitude(statement)).to eq "agreeing"
          end
        end

        context "when the creator has voted pro" do
          before { FactoryGirl.create(:vote, :down, voteable: statement, user: user) }
          it "returns an appropriate code" do
            expect(helper.creator_attitude(statement)).to eq "disagreeing"
          end
        end
      end
    end
  end

  describe "#body" do
    let(:statement) { FactoryGirl.create(:statement) }
    let(:thesis_de) { "Das ist so!" }
    let(:thesis_en) { "It is so!" }

    before(:context) { I18n.locale = :de }
    after(:context) { I18n.locale = I18n.default_locale }

    context "when called with a statement" do
      context "when called without second argument" do
        context "when statement has a body" do
          context "when body exists in the current locale" do
            before do
              statement.body = {thesis: {de: thesis_de}}
              statement.save! validate: false
            end

            it "returns the body in the current locale" do
              expect(helper.body(statement)).to eq thesis_de
            end
          end

          context "when body doesn't exist in the current locale" do
            context "when original locale is set" do
              context "when a body is found in that locale" do
                before do
                  statement.body = {original_locale: "en", thesis: {en: thesis_en}}
                  statement.save! validate: false
                end

                it "returns the body in the original locale" do
                  expect(helper.body(statement)).to eq thesis_en
                end
              end

              context "when no body is found in that locale" do
                before do
                  statement.body = {original_locale: "en", thesis: {fr: thesis_en}}
                  statement.save! validate: false
                end

                it "returns the first found body" do
                  expect(helper.body(statement)).to eq thesis_en
                end
              end
            end

            context "when original locale is not set" do
              context "when a body exists in any language" do
                before do
                  statement.body = {thesis: {en: thesis_en}}
                  statement.save! validate: false
                end

                it "returns the first found body" do
                  expect(helper.body(statement)).to eq thesis_en
                end
              end

              context "when no body exists in any language" do
                before do
                  statement.body = {}
                  statement.save! validate: false
                end

                it "returns a warning" do
                  expect(helper.body(statement)).to eq "N/A"
                end
              end
            end
          end
        end
      end

      context "when called with true as second argument" do
        context "when statement has a body" do
          context "when body exists in the current locale" do
            before do
              statement.body = {counter_thesis: {de: thesis_de}}
              statement.save! validate: false
            end

            it "returns the body in the current locale" do
              expect(helper.body(statement, true)).to eq thesis_de
            end
          end

          context "when body doesn't exist in the current locale" do
            context "when original locale is set" do
              context "when a body is found in that locale" do
                before do
                  statement.body = {original_locale: "en", counter_thesis: {en: thesis_en}}
                  statement.save! validate: false
                end

                it "returns the body in the original locale" do
                  expect(helper.body(statement, true)).to eq thesis_en
                end
              end

              context "when no body is found in that locale" do
                before do
                  statement.body = {original_locale: "en", counter_thesis: {fr: thesis_en}}
                  statement.save! validate: false
                end

                it "returns the first found body" do
                  expect(helper.body(statement, true)).to eq thesis_en
                end
              end
            end

            context "when original locale is not set" do
              context "when a body exists in any language" do
                before do
                  statement.body = {counter_thesis: {en: thesis_en}}
                  statement.save! validate: false
                end

                it "returns the first found body" do
                  expect(helper.body(statement, true)).to eq thesis_en
                end
              end

              context "when no body exists in any language" do
                before do
                  statement.body = {thesis: {de: thesis_de}}
                  statement.save! validate: false
                end

                it "returns a warning" do
                  expect(helper.body(statement, true)).to eq "N/A"
                end
              end
            end
          end
        end
      end
    end

    context "when called with nil" do
      it "returns a warning" do
        expect(helper.body(nil)).to eq "N/A"
      end
    end
  end
end
