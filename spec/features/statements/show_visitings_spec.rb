require 'rails_helper'

RSpec.feature "StatementShowVisitings", type: :feature do
  let(:statement) { FactoryGirl.create(:statement) }

  it "displays the statement body as headline" do
    visit statement_path(statement)
    expect(page).to have_content(statement.body)
  end

  describe "arguments" do
    let!(:pro_arguments) do
      FactoryGirl.create_list(:statement_argument_link, 2, :pro, statement: statement).map { |link| link.argument }
    end
    let!(:contra_arguments) do
      FactoryGirl.create_list(:statement_argument_link, 2, :contra, statement: statement).map { |link| link.argument }
    end

    before { visit statement_path(statement) }

    it "displays link to create a new contra argument" do
      expect(page).to have_link(I18n.t("statements.show.links.new_contra_argument"), href: new_statement_path(contra: statement.id))
    end

    it "displays link to create a new pro argument" do
      expect(page).to have_link(I18n.t("statements.show.links.new_pro_argument"), href: new_statement_path(pro: statement.id))
    end

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

  describe "comments" do
    context "when comments for this statement exist" do
      it "displays all comments" do
        # Note! For the test it is important that the comments have pairwise distinct
        # bodies. This is achieved by the sequential definition of the body attribute
        # in the comment factory.
        comments = FactoryGirl.create_list(:comment, 30, commentable: statement)

        visit statement_path(statement)

        comments.each do |comment|
          expect(page).to have_content(comment.body)
        end
      end
    end
  end

  describe "back button" do
    let(:statement_argument_link) { FactoryGirl.create(:statement_argument_link) }
    let(:statement_1) { statement_argument_link.statement }
    let(:statement_2) { statement_argument_link.argument }

    context "when the user has already visited two pages" do
      before do
        visit statement_path(statement_1)

        # Since statement_2 is an argument for statement_1, a link
        # to statement_2 should exist on the page for statement_1.
        click_link statement_2.body
      end

      it "brings the user back to the previously visited page" do
        click_link I18n.t("links.back")
        expect(page.current_path).to eq statement_path(statement_1)
      end
    end

    context "when the user has visited only one page yet" do
      before do
        visit statement_path(statement_1)
      end

      it "brings the user back to the previously visited page" do
        click_link I18n.t("links.back")

        # It doesn't do anything.
        expect(page.current_path).to eq statement_path(statement_1)
      end
    end
  end
end
