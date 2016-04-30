require 'rails_helper'

RSpec.describe Users::ProfilesController, type: :controller do

  describe "GET #edit" do
    let(:user) { FactoryGirl.create(:user) }

    def valid_request
      get :edit
    end

    context "when a user is signed in" do
      before { sign_in user }

      include_examples "Successful request"
    end

    context "when no user is signed in" do
      before { valid_request }
      
      include_examples "Not signed in"
    end
  end

  describe "PUT #update" do
    let(:user) { FactoryGirl.create(:user) }
    let(:updated_name) { user.name + "a" }

    def valid_request
      put :update, params: {user: {name: updated_name}}
    end

    context "when a user is signed in" do
      before { sign_in user }

      context "when update is valid" do
        before { valid_request }

        it "updates the user" do
          expect(user.reload.name).to eq updated_name
        end
      end
    end

    context "when no user is signed in" do
      before { valid_request }
      
      include_examples "Not signed in"
    end
  end

end
