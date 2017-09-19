require "rails_helper"

RSpec.describe Devise::Mailer, type: :mailer do
  describe "Confirmation instructions email" do
    let(:user) { FactoryGirl.build(:user, :unconfirmed) }
    let(:token) { "iorwfe459okladwgre" }
    let(:options) { {} }
    let(:mail) { described_class.confirmation_instructions(user, token, options).deliver_now }

    it "renders the subject" do
      expect(mail.subject).to eq(I18n.t("devise.mailer.confirmation_instructions.subject"))
    end

    it "renders the receiver email" do
      expect(mail.to).to eq([user.email])
    end

    it "renders the sender email" do
      expect(mail.from).to eq(["info@debae.org"])
    end

    it "displays link to debae" do
      expect(mail.body.encoded).to have_link("debae", href: root_url)
    end

    it "displays link to confirm the email" do
      expect(mail.body.encoded).to have_link(
        I18n.t("mailers.devise.confirmation_instructions.confirmation_link"),
        href: user_confirmation_url(confirmation_token: token)
      )
    end
  end

  describe "Password change email" do
    let(:user) { FactoryGirl.build(:user, :unconfirmed) }
    let(:options) { {} }
    let(:mail) { described_class.password_change(user, options).deliver_now }

    it "renders the subject" do
      expect(mail.subject).to eq(I18n.t("devise.mailer.password_change.subject"))
    end

    it "renders the receiver email" do
      expect(mail.to).to eq([user.email])
    end

    it "renders the sender email" do
      expect(mail.from).to eq(["info@debae.org"])
    end

    it "displays link to debae" do
      expect(mail.body.encoded).to have_link("debae", href: root_url)
    end
  end

  describe "Reset password instructions email" do
    let(:user) { FactoryGirl.build(:user) }
    let(:token) { "iorwfe459okladwgre" }
    let(:options) { {} }
    let(:mail) { described_class.reset_password_instructions(user, token, options).deliver_now }

    it "renders the subject" do
      expect(mail.subject).to eq(I18n.t("devise.mailer.reset_password_instructions.subject"))
    end

    it "renders the receiver email" do
      expect(mail.to).to eq([user.email])
    end

    it "renders the sender email" do
      expect(mail.from).to eq(["info@debae.org"])
    end

    it "displays link to debae" do
      expect(mail.body.encoded).to have_link("debae", href: root_url)
    end

    it "displays link to reset password" do
      expect(mail.body.encoded).to have_link(
        I18n.t("mailers.devise.reset_password_instructions.reset_link"),
        href: edit_user_password_url(reset_password_token: token)
      )
    end
  end
end
