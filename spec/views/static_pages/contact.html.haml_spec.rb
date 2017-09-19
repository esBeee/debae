require 'rails_helper'

RSpec.describe "static_pages/contact.html.haml", type: :view do
  before { render }

  it 'displays link to contact email address' do
    expect(rendered).to have_link('info@debae.org', href: 'mailto:info@debae.org')
  end
end
