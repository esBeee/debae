require 'rails_helper'

RSpec.shared_examples "A successful statement creation" do
  it "creates a new statement for the logged in user" do
    expect(statement).not_to be nil
    expect(statement.user).to eq user
  end
end

# Here, the direction parameter should be either
#           pro       or       contra 
RSpec.shared_examples "A successful argument creation" do |direction|
  it_behaves_like "A successful statement creation"

  it "redirects to the supported statement's page" do
    expect(page.current_path).to eq statement_path(statement_to_support)
  end

  it "creates a link to the statement to be backed" do
    expect(statement_to_support.send(direction + "_arguments")).to include(statement)
  end
end

RSpec.shared_examples "A failed statement creation" do
  it "doesn't creates a new statement for the logged in user" do
    expect(user.statements.count).to eq 0
  end

  it "displays errors" do
    pending "This test should be completed as soon as a strategy of displaying errors has been implemented"
    expect(page).to have_css(".errors")
  end
end

RSpec.feature "StatementCreations", type: :feature, session_helpers: true do
  let(:user) { FactoryGirl.create(:user) }
  let(:statement) { Statement.find_by(body: new_statement_body) }
  # Create new statement body with timestamp to ensure this test doesn't succeeds because
  # there's already a statement with that body in the database.
  let(:new_statement_body) { "This and that is right. I know it! #{Time.now.to_i}" }
  let(:statement_to_support) { FactoryGirl.create(:statement) }

  # A helper to fill in the form and submit it.
  def fill_form_and_submit body
    # Fill in my statement
    fill_in I18n.t("statements.new.body"), with: body

    # Submit
    click_button I18n.t("statements.new.submit")
  end

  # Sign in the user. Necessary for all cases.
  before do
    # Creations are only allowed for signed in users. So
    # signing in before.
    sign_in user
  end

  context "when statement is valid" do
    context "when creating as a top-level-statement" do
      before do
        visit new_statement_path
        fill_form_and_submit(new_statement_body)
      end

      it_behaves_like "A successful statement creation"

      it "redirects to the new statement's page" do
        expect(page.current_path).to eq statement_path(statement)
      end

      it "sets the statement's :top_level attribute to true" do
        expect(statement.top_level).to eq true
      end
    end

    context "when creating as a pro argument" do
      before do
        # The creation as a pro argument should be possible by
        # adding the query parameter 'pro' whose value is
        # the id of the statement to back.
        visit new_statement_path(pro: statement_to_support.id)
        fill_form_and_submit(new_statement_body)
      end

      it_behaves_like "A successful argument creation", "pro"

      it "sets the statement's :top_level attribute to false" do
        expect(statement.top_level).to eq false
      end
    end

    context "when creating as a contra argument" do
      before do
        # The creation as a contra argument should be possible by
        # adding the query parameter 'contra' whose value is
        # the id of the statement to back.
        visit new_statement_path(contra: statement_to_support.id)
        fill_form_and_submit(new_statement_body)
      end

      it_behaves_like "A successful argument creation", "contra"

      it "sets the statement's :top_level attribute to false" do
        expect(statement.top_level).to eq false
      end
    end
  end

  context "when statement is invalid" do
    # Choose an invalid statement body for this test.
    let(:invalid_statement_body) { " " }

    context "when creating as a top-level-statement" do
      before do
        visit new_statement_path
        fill_form_and_submit(invalid_statement_body)
      end

      it_behaves_like "A failed statement creation"

      # Test that after the creation failed, I don't have to do
      # anything else but correct the invalid field to finally create
      # the statement.
      describe "correcting the input data" do
        before do
          fill_form_and_submit(new_statement_body)
        end

        it_behaves_like "A successful statement creation"

        it "redirects to the new statement's page" do
          expect(page.current_path).to eq statement_path(statement)
        end

        it "sets the statement's :top_level attribute to true" do
          expect(statement.top_level).to eq true
        end
      end
    end

    context "when creating as a pro argument" do
      before do
        # The creation as a pro argument should be possible by
        # adding the query parameter 'pro' whose value is
        # the id of the statement to back.
        visit new_statement_path(pro: statement_to_support.id)
        fill_form_and_submit(invalid_statement_body)
      end

      it_behaves_like "A failed statement creation"

      # Test that after the creation failed, I don't have to do
      # anything else but correct the invalid field to finally create
      # the statement.
      describe "correcting the input data" do
        before do
          fill_form_and_submit(new_statement_body)
        end

        it_behaves_like "A successful argument creation", "pro"

        it "sets the statement's :top_level attribute to false" do
          expect(statement.top_level).to eq false
        end
      end
    end

    context "when creating as a contra argument" do
      before do
        # The creation as a contra argument should be possible by
        # adding the query parameter 'contra' whose value is
        # the id of the statement to back.
        visit new_statement_path(contra: statement_to_support.id)
        fill_form_and_submit(invalid_statement_body)
      end

      it_behaves_like "A failed statement creation"

      # Test that after the creation failed, I don't have to do
      # anything else but correct the invalid field to finally create
      # the statement.
      describe "correcting the input data" do
        before do
          fill_form_and_submit(new_statement_body)
        end

        it_behaves_like "A successful argument creation", "contra"

        it "sets the statement's :top_level attribute to false" do
          expect(statement.top_level).to eq false
        end
      end
    end
  end
end
