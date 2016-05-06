require 'rails_helper'

RSpec.feature "StatementShowVisitings", type: :feature, statements_helper: true do
  let(:statement) { FactoryGirl.create(:statement) }

  it "displays the statement body as headline" do
    visit statement_path(statement)
    expect(page).to have_content(body(statement))
  end

  describe "arguments" do
    let(:pro_container_css) { ".arguments-container.pro" }
    let(:contra_container_css) { ".arguments-container.contra" }

    context "when arguments exist" do
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
        it "displays pro arguments" do
          within(:css, pro_container_css) do
            pro_arguments.each do |statement|
              expect(page).to have_content(body(statement))
            end
          end
        end

        it "doesn't display contra arguments" do
          within(:css, pro_container_css) do
            contra_arguments.each do |statement|
              expect(page).not_to have_content(body(statement))
            end
          end
        end
      end

      describe "contra arguments section" do
        it "displays contra arguments" do
          within(:css, contra_container_css) do
            contra_arguments.each do |statement|
              expect(page).to have_content(body(statement))
            end
          end
        end

        it "doesn't display pro arguments" do
          within(:css, contra_container_css) do
            pro_arguments.each do |statement|
              expect(page).not_to have_content(body(statement))
            end
          end
        end
      end
    end

    context "when no arguments exist" do
      before { visit statement_path(statement) }

      it "displays link to create a new contra argument" do
        expect(page).to have_link(I18n.t("statements.show.links.new_contra_argument"), href: new_statement_path(contra: statement.id))
      end

      it "displays link to create a new pro argument" do
        expect(page).to have_link(I18n.t("statements.show.links.new_pro_argument"), href: new_statement_path(pro: statement.id))
      end

      describe "pro arguments section" do
        it "displays empty message" do
          within(:css, pro_container_css) do
            expect(page).to have_content(I18n.t("statements.show.no_pro_arguments"))
          end
        end
      end

      describe "contra arguments section" do
        it "displays empty message" do
          within(:css, contra_container_css) do
            expect(page).to have_content(I18n.t("statements.show.no_contra_arguments"))
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
          expect(page).to have_content(body(comment))
        end
      end
    end
  end
end
