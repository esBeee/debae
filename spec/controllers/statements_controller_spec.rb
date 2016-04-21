require 'rails_helper'

RSpec.describe StatementsController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    context "when the requested statement exists" do
      let(:statement) { FactoryGirl.create(:statement) }

      it "returns http success" do
        get :show, params: { id: statement.id }
        expect(response).to have_http_status(:success)
      end
    end

    context "when the requested statement doesn't exist" do
      let(:statement) { FactoryGirl.create(:statement) }

      it "raises a routing error" do
        # Make sure the statement doesn't exist anymore
        # before requesting.
        statement.destroy

        error_thrown = false

        # Request
        begin
          get :show, params: { id: statement.id }
        rescue ActionController::RoutingError => e
          error_thrown = true
        end

        expect(error_thrown).to be true
      end
    end
  end
end
