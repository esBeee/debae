require 'rails_helper'

RSpec.describe StatementsController, type: :controller do
  describe "GET #index" do
    before { get :index }
    include_examples "Successful request"
  end

  describe "GET #show" do
    context "when the requested statement exists" do
      let(:statement) { FactoryGirl.create(:statement) }

      before { get :show, params: { id: statement.id } }

      include_examples "Successful request"
    end

    context "when the requested statement doesn't exist" do
      let(:statement) { FactoryGirl.create(:statement) }

      before do
        # Make sure the statement doesn't exist anymore
        # before requesting.
        statement.destroy

        get :show, params: { id: statement.id }
      end

      include_examples "Resource not found"
    end
  end

  describe "GET #new" do
    context "when a user is signed in" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        sign_in user
        get :new
      end

      include_examples "Successful request"
    end

    context "when no user is signed in" do
      before { get :new }
      include_examples "Not signed in"
    end
  end

  describe "POST #create" do
    context "when a user is signed in" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        sign_in user
        post :create, params: {statement: {body: ""}}
      end

      include_examples "Successful request"
    end

    context "when no user is signed in" do
      before { post :create }
      include_examples "Not signed in"
    end
  end
end
