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
end
