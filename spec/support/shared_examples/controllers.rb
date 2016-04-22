# Contains shared examples for controller spex.
module SharedExamples
  module Controllers
    # Tests the standard procedere for not found
    RSpec.shared_examples "Resource not found" do
      it "redirects to the root path" do
        expect(response).to redirect_to(:root)
      end

      it "sets flash error" do
        expect(flash[:error]).to eq I18n.t("actioncontroller.errors.not_found")
      end
    end

    # Tests the standard procedere for not signed in
    RSpec.shared_examples "Not signed in" do
      it "redirects to sign-in page if no user is logged in" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    # Tests the standard procedere for a successful request
    RSpec.shared_examples "Successful request" do
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end
  end
end
