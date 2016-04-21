require 'rails_helper'

RSpec.feature "StatementShowVisitings", type: :feature do
  let(:statement) { FactoryGirl.create(:statement) }

  it "displays the statement body as headline" do
    visit statement_path(statement)
    expect(page).to have_content(statement.body)
  end

  describe "arguments" do
    let!(:pro_arguments) do
      FactoryGirl.create_list(:link_to_argument, 2, :pro, statement: statement).map { |link| link.argument }
    end
    let!(:contra_arguments) do
      FactoryGirl.create_list(:link_to_argument, 2, :contra, statement: statement).map { |link| link.argument }
    end

    before { visit statement_path(statement) }

    describe "pro arguments section" do
      let(:container_css) { ".arguments.pro" }

      it "displays pro arguments" do
        within(:css, container_css) do
          pro_arguments.each do |statement|
            expect(page).to have_content(statement.body)
          end
        end
      end

      it "doesn't display contra arguments" do
        within(:css, container_css) do
          contra_arguments.each do |statement|
            expect(page).not_to have_content(statement.body)
          end
        end
      end
    end

    describe "contra arguments section" do
      let(:container_css) { ".arguments.contra" }

      it "displays contra arguments" do
        within(:css, container_css) do
          contra_arguments.each do |statement|
            expect(page).to have_content(statement.body)
          end
        end
      end

      it "doesn't display pro arguments" do
        within(:css, container_css) do
          pro_arguments.each do |statement|
            expect(page).not_to have_content(statement.body)
          end
        end
      end
    end
  end
end
