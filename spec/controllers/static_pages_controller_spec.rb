require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe "GET #about" do
    before { get :about }
    include_examples "Successful request"
  end
end
