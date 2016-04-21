require 'rails_helper'

RSpec.feature "IndexVisitings", type: :feature do
  describe "lists statements" do
    # It's very important that the statements created here have pairwise distinc
    # values for the body attribute. Otherwise tests in this file will not
    # work as expected.
    # Currently this is achieved by sequentially creating the body in
    # the file factories/statements.rb.
    let!(:first_page_statements) { FactoryGirl.create_list(:statement, 10) }
    let!(:second_page_statements) { FactoryGirl.create_list(:statement, 10, created_at: Time.now - 1.day) }

    context "when page 1 was chosen" do
      before { visit statements_path(page: 1) }

      it "displays the 10 newest statements" do
        first_page_statements.each do |statement|
          expect(page).to have_content(statement.body)
        end
      end

      it "doesn't display the 10 page 2 statements" do
        second_page_statements.each do |statement|
          expect(page).not_to have_content(statement.body)
        end
      end
    end

    context "when no explicit page was chosen" do
      before { visit statements_path }

      it "displays the 10 newest statements" do
        first_page_statements.each do |statement|
          expect(page).to have_content(statement.body)
        end
      end

      it "doesn't display the 10 page 2 statements" do
        second_page_statements.each do |statement|
          expect(page).not_to have_content(statement.body)
        end
      end
    end

    context "when page 2 was chosen" do
      before { visit statements_path(page: 2) }

      it "doesn't display the 10 newest statements" do
        first_page_statements.each do |statement|
          expect(page).not_to have_content(statement.body)
        end
      end

      it "displays the 10 page 2 statements" do
        second_page_statements.each do |statement|
          expect(page).to have_content(statement.body)
        end
      end
    end
  end
end
