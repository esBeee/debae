require 'rails_helper'

RSpec.feature "StaticPagesContactVisitings", type: :feature do
  it "displays the headline" do
    visit about_path
    expect(page).to have_content(I18n.t("static_pages.about.headline_score"))
  end
end
