require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#page_title" do
    context "when first argument is a blank string" do
      it "returns the default title" do
        expect(page_title(" ")).to eq I18n.t("layouts.title") + " | debae"
      end
    end

    context "when first argument is nil" do
      it "returns the default title" do
        expect(page_title(nil)).to eq I18n.t("layouts.title") + " | debae"
      end
    end

    context "when first argument is a valid description" do
      let(:description) { "This page is about this and that" }
      it "returns a composed title" do
        expect(page_title(description)).to eq "#{description} | debae"
      end
    end
  end

  describe "#page_description" do
    context "when first argument is a blank string" do
      it "returns the default description" do
        expect(page_description(" ")).to eq I18n.t("layouts.description")
      end
    end

    context "when first argument is nil" do
      it "returns the default description" do
        expect(page_description(nil)).to eq I18n.t("layouts.description")
      end
    end

    context "when first argument is a valid description" do
      let(:description) { "This page is about this and that." }
      it "returns the given description" do
        expect(page_description(description)).to eq description
      end
    end
  end
end
