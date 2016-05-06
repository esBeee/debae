require 'rails_helper'

RSpec.feature "BackButton", type: :feature, statements_helper: true do
  pending "Now only works with JS and local browser storage."
  # let(:statement_argument_link) { FactoryGirl.create(:statement_argument_link) }
  # let(:statement_1) { statement_argument_link.statement }
  # let(:statement_2) { statement_argument_link.argument }

  # let(:back_link_id) { "i.fa-arrow-circle-left" }

  # context "when the user has already visited two pages" do
  #   before do
  #     visit statement_path(statement_1)

  #     # Since statement_2 is an argument for statement_1, a link
  #     # to statement_2 should exist on the page for statement_1.
  #     click_link body(statement_2)
  #   end

  #   it "brings the user back to the previously visited page" do
  #     find(back_link_id).click
  #     pending "This test doesn't work for any reason"
  #     expect(page.current_path).to eq statement_path(statement_1)
  #   end
  # end
end
