require 'rails_helper'

RSpec.feature "UserOAuthSignIns", type: :feature do
  let(:uid) { "ui390u42tkjglw5h4jh234t35ht" }
  let(:email) { "jkfw@rehgfs.com" }
  let(:name) { "Maxima Meritas" }
  let(:link_to_social_profile) { "https://www.facebook.com" }
  
  before :all do
    OmniAuth.config.test_mode = true
  end

  after :all do
    OmniAuth.config.test_mode = false
  end

  before :each do
    # Set default auth responses for all 3 providers.
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: "facebook",
      uid: uid,
      info: {
        email: email,
        name: name,
        urls: {
          Facebook: link_to_social_profile
        }
      }
    })

    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: "twitter",
      uid: uid,
      info: {
        name: name,
        urls: {
          Twitter: link_to_social_profile
        }
      }
    })

    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: "google_oauth2",
      uid: uid,
      info: {
        email: email,
        name: name,
        urls: {
          Google: link_to_social_profile
        }
      }
    })
  end

  def link_to_name provider
    case provider
    when :facebook then :link_to_facebook
    when :google_oauth2 then :link_to_google_plus
    when :twitter then :link_to_twitter
    end
  end

  [:facebook, :twitter, :google_oauth2].each do |provider|
    describe "#{provider} OAuth" do
      let(:readable_provider) { provider.to_s.split("_").first.capitalize }
      let(:link_identifier) { I18n.t("layouts.header.links.sign_in", auth_type: readable_provider) }
      let(:success_flash) { I18n.t("devise.omniauth_callbacks.success", kind: provider.to_s.capitalize) }

      context "when uid-provider-pair doesn't exist yet" do
        before do
          # Create a user that has this uid but with another provider
          # just to make sure this doesn't change the expected behaviour.
          FactoryGirl.create(:user, uids: {bluebook: uid})
          FactoryGirl.create(:user, uids: {provider => "n3tnkw"})
        end

        it "a user with this uid-provider-pair doesn't exist" do
          expect(User.where("uids ->> '#{provider}' = ?", uid).count).to eq 0
        end

        context "when delivered email doesn't belong to an exisiting user" do
          let(:user) { User.find_by("uids ->> '#{provider}' = ?", uid) }

          before do
            visit root_path
            click_link link_identifier
          end

          it "creates a new user for this provider-uid-pair" do
            expect(User.where("uids ->> '#{provider}' = ?", uid).count).to eq 1
          end

          it "saves the link to the social profile" do
            expect(user.send(link_to_name(provider))).to eq link_to_social_profile
          end

          it "saves the user's name" do
            expect(user.name).to eq name
          end

          it "signs the user in" do
            expect(page).to have_content(success_flash)
          end

          unless provider == :twitter
            it "saves the user's email" do
              expect(user.email).to eq email
            end
          end
        end

        unless provider == :twitter
          context "when delivered email belongs to an exisiting user" do
            let!(:user) { FactoryGirl.create(:user, email: email, name: name + "a",
              uids: {bluebook: "sorimk"}) }

            before do
              visit root_path
              click_link link_identifier

              # Make sure we're comparing the latest data.
              user.reload
            end

            it "updates the user with this provider-uid-pair" do
              expect(user.send(provider)).to eq uid
            end

            it "saves the link to the social profile" do
              expect(user.send(link_to_name(provider))).to eq link_to_social_profile
            end

            it "doesn't update the user's name" do
              expect(user.name).not_to eq name
            end

            it "signs the user in" do
              expect(page).to have_content(success_flash)
            end

            it "doesn't destroy other saved uids" do
              expect(user.uids["bluebook"]).to eq "sorimk"
            end
          end
        end
      end

      context "when uid-provider-pair already exists" do
        let!(:user) { FactoryGirl.create(:user, uids: {provider => uid}, name: name + "a",
          link_to_name(provider) => link_to_social_profile + "s") }

        before do
          visit root_path
          click_link link_identifier

          # Make sure we're comparing the latest data.
          user.reload
        end

        it "doesn't create another user for this provider-uid-pair" do
          expect(User.where("uids ->> '#{provider}' = ?", uid).count).to eq 1
        end

        it "doesn't update the link to the social profile" do
          expect(user.send(link_to_name(provider))).not_to eq link_to_social_profile
        end

        it "doesn't update the user's name" do
          expect(user.name).not_to eq name
        end

        it "signs the user in" do
          expect(page).to have_content(success_flash)
        end

        unless provider == :twitter
          it "doesn't update the user's email" do
            expect(user.email).not_to eq email
          end
        end
      end
    end
  end

end
