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

  describe "GET #new" do
    context "when a user is signed in" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        sign_in user
        get :new
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "when no user is signed in" do
      before { get :new }

      it "redirects to sign-in page if no user is logged in" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST #create" do
    context "when a user is signed in" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        sign_in user
        post :create, params: {statement: {body: ""}}
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "when no user is signed in" do
      before { post :create }
      
      it "redirects to sign-in page if no user is logged in" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
