require 'rails_helper'

RSpec.feature "StaticPagesContactVisitings", type: :feature do
  it "displays the headline" do
    visit contact_path
    expect(page).to have_content(I18n.t("static_pages.contact.headline"))
  end
end
