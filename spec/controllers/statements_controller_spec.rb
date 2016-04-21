require 'rails_helper'

RSpec.describe StatementsController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    let(:statement) { FactoryGirl.create(:statement) }

    it "returns http success" do
      get :show, params: { id: statement.id }
      expect(response).to have_http_status(:success)
    end
  end
end
