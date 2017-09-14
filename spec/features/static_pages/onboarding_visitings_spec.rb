require 'rails_helper'

RSpec.feature "StaticPagesOnboardingVisitings", type: :feature do
  it "displays the headline for the 'discuss' section" do
    visit root_path
    expect(page).to have_content(I18n.t("static_pages.onboarding.headline_discuss"))
  end
end
