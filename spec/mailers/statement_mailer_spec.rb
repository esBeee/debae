require "rails_helper"

RSpec.describe StatementMailer, type: :mailer do
  describe "New argument email" do
    let(:link) { FactoryGirl.build(:statement_argument_link) }
    let(:mail) { described_class.new_argument_email(link).deliver_now }

    it "renders the subject" do
      expect(mail.subject).to eq(I18n.t("mailers.statements.new_argument_email.subject"))
    end

    it "renders the receiver email" do
      expect(mail.to).to eq([link.statement.user.email])
    end

    it "renders the sender email" do
      expect(mail.from).to eq(["no-reply@debae.de"])
    end

    it "displays body of the new argument" do
      expect(mail.body.encoded).to have_content(link.argument.body)
    end

    it "displays link to statement" do
      statement = link.statement
      expect(mail.body.encoded).to have_link(statement.body, href: statement_url(statement))
    end
  end
end
