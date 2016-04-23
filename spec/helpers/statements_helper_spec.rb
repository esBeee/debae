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
        expect(helper.argument_hash(statement_to_support_id, nil)).to eq ([statement_to_support_id, true])
      end
    end

    # When called with the second argument, it is assumed that the second
    # argument can be interpreted as the id of the statement this
    # statement should support as a contra argument.
    context "when called with only the second argument" do
      it "returns a hash containing all necessary information" do
        expect(helper.argument_hash(nil, statement_to_support_id)).to eq ([statement_to_support_id, false])
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
end
