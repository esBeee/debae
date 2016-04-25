require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "POST #create" do
    let(:user) { FactoryGirl.create(:user) }
    let(:commentable) { FactoryGirl.create(:statement) }

    def valid_request
      post :create, params: {comment: {commentable_id: commentable.id, commentable_type: commentable.class.to_s, body: "This and that!"}}
    end

    context "when a user is signed in" do
      before { sign_in user }

      context "when comment is valid" do
        before { valid_request }

        it "redirects to the page of the commentable" do
          expect(response).to redirect_to(commentable)
        end
      end

      context "when comment is invalid (should be prevented by front-end)" do
        before { valid_request }

        it "redirects to the page of the commentable" do
          expect(response).to redirect_to(commentable)
        end
      end
    end

    context "when no user is signed in" do
      before { valid_request }
      
      include_examples "Not signed in"
    end
  end

end
