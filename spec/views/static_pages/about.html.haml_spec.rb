require 'rails_helper'

RSpec.describe "static_pages/about.html.haml", type: :view do
  before { render }

  it 'displays link to contact email address' do
    expect(rendered).to have_link('info@debae.org', href: 'mailto:info@debae.org')
  end

  it 'displays link to GitHub repository' do
    expect(rendered).to have_link('GitHub', href: 'https://github.com/esBeee/debae')
  end

  it 'displays link to formulary' do
    expect(rendered).to have_link(nil, href: 'https://github.com/esBeee/debae/blob/master/app/scoring/formulary.rb')
  end
end
