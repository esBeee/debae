require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  describe "POST #create" do
    let(:user) { FactoryGirl.create(:user) }
    let(:voteable) { FactoryGirl.create(:statement) }

    def valid_request
      post :create, params: {vote: {is_pro_vote: true, voteable_id: voteable.id, voteable_type: voteable.class.to_s}}
    end

    context "when a user is signed in" do
      before { sign_in user }

      context "when voteable is valid" do
        before { valid_request }

        it "redirects to the page of the voteable" do
          expect(response).to redirect_to(voteable)
        end
      end
    end

    context "when no user is signed in" do
      before { valid_request }
      
      include_examples "Not signed in"
    end
  end

  describe "DELETE #destroy" do
    let(:user) { FactoryGirl.create(:user) }

    def valid_request vote_id = "1"
      delete :destroy, params: {id: vote_id}
    end

    context "when a user is signed in" do
      before { sign_in user }

      context "when user is owner of the vote" do
        let(:vote) { FactoryGirl.create(:vote, user: user) } # A vote by the signed in user
        let(:statement) { vote.voteable }

        before { valid_request vote.id }

        it "redirects to the page of the statement the vote referred to" do
          expect(response).to redirect_to(statement)
        end

        it "destroys the vote" do
          expect(Vote.find_by(id: vote.id)).to eq nil
        end
      end

      context "when user is not owner of the vote" do
        let(:vote) { FactoryGirl.create(:vote) } # A vote by some new user
        let(:statement) { vote.statement }

        before { valid_request vote.id }

        it "redirects to the root path" do
          expect(response).to redirect_to(:root)
        end

        it "sets flash error" do
          expect(flash[:error]).to eq I18n.t("actioncontroller.errors.unauthorized")
        end

        it "doesn't destroy the vote" do
          expect(Vote.find_by(id: vote.id)).not_to eq nil
        end
      end

      context "when vote doesn't exist" do
        let(:vote) { FactoryGirl.create(:vote, user: user) } # A vote by the signed in user
        let(:statement) { vote.statement }

        before do
          # Destroy the vote before requesting
          vote.destroy

          valid_request vote.id
        end

        include_examples "Resource not found"
      end
    end

    context "when no user is signed in" do
      before { valid_request }
      
      include_examples "Not signed in"
    end
  end

end
