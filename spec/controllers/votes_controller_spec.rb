require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  describe "POST #create" do
    let(:user) { FactoryGirl.create(:user) }
    let(:statement) { FactoryGirl.create(:statement) }

    def valid_request statement_id = "1"
      post :create, params: {statement_id: statement_id, vote: {is_pro_vote: true}}
    end

    context "when a user is signed in" do
      before { sign_in user }

      context "when statement exists" do
        before { valid_request statement.id }

        it "redirects to the page of the statement" do
          expect(response).to redirect_to(statement)
        end
      end

      context "when statement doesn't exist" do
        before do
          # Make sure the statement doesn't exist anymore
          # before requesting.
          statement.destroy
        end

        it "raises a routing error" do
          error_thrown = false

          # Request
          begin
            valid_request statement.id
          rescue ActionController::RoutingError => e
            error_thrown = true
          end

          expect(error_thrown).to be true
        end
      end
    end

    context "when no user is signed in" do
      before { valid_request }
      
      it "redirects to sign-in page if no user is logged in" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

end
