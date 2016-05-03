require 'rails_helper'

RSpec.feature "StatementIndexVisitings", type: :feature, statements_helper: true do
  let(:statements_per_page) { WillPaginate.per_page }

  describe "lists statements" do
    # It's very important that the statements created here have pairwise distinc
    # values for the body attribute. Otherwise tests in this file will not
    # work as expected.
    # Currently this is achieved by sequentially creating the body in
    # the file factories/statements.rb.
    #
    # The bang is important to make sure all statements exist before
    # visiting the index page.
    let!(:first_page_statements) { FactoryGirl.create_list(:statement, statements_per_page) }
    let!(:second_page_statements) { FactoryGirl.create_list(:statement, statements_per_page, created_at: Time.now - 1.day) }

    context "when page 1 was chosen" do
      before { visit statements_path(page: 1) }

      it "displays the newest statements" do
        first_page_statements.each do |statement|
          expect(page).to have_content(body(statement))
        end
      end

      it "doesn't display the page 2 statements" do
        second_page_statements.each do |statement|
          expect(page).not_to have_content(body(statement))
        end
      end
    end

    context "when no explicit page was chosen" do
      before { visit statements_path }

      it "displays the newest statements" do
        first_page_statements.each do |statement|
          expect(page).to have_content(body(statement))
        end
      end

      it "doesn't display the page 2 statements" do
        second_page_statements.each do |statement|
          expect(page).not_to have_content(body(statement))
        end
      end
    end

    context "when page 2 was chosen" do
      before { visit statements_path(page: 2) }

      it "doesn't display the newest statements" do
        first_page_statements.each do |statement|
          expect(page).not_to have_content(body(statement))
        end
      end

      it "displays the page 2 statements" do
        second_page_statements.each do |statement|
          expect(page).to have_content(body(statement))
        end
      end
    end
  end

  describe "links to listed statements" do
    let!(:statements) { FactoryGirl.create_list(:statement, 2) }

    before { visit statements_path }

    it "displays link to statements" do
      statements.each do |statement|
        expect(page).to have_link(body(statement), href: statement_path(statement))
      end
    end
  end

  # Just test that the pagination links are there.
  # Since the links stem from gem will_paginate, no indepth testing
  # will be done here.
  describe "pagination links" do
    let(:link_to_next_page) { I18n.t("will_paginate.next_label") }

    context "when more than one page of statements is available" do
      let!(:statements) { FactoryGirl.create_list(:statement, statements_per_page + 1) }
      let(:path_to_next_page) { "/?page=2" }

      before { visit statements_path }

      it "displays link to the next page" do
        expect(page).to have_link(link_to_next_page, href: path_to_next_page)
      end
    end

    context "when not more than one page of statements is available" do
      let!(:statements) { FactoryGirl.create_list(:statement, statements_per_page) }

      before { visit statements_path }

      it "doesn't display link to the next page" do
        expect(page).not_to have_link(link_to_next_page)
      end
    end
  end
end
