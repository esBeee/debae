require 'rails_helper'

RSpec.describe "statements/show.html.erb", type: :view do
  let(:statement) { FactoryGirl.build_stubbed(:statement) }

  before do
    assign(:statement, statement)
    render
  end

  it "displays the statements body as <h1>" do
    expect(rendered).to include("<h1>" + statement.body + "</h1>")
  end

  it "displays container for pro arguments" do
    expect(rendered).to have_css(".arguments.pro")
  end

  it "displays container for contra arguments" do
    expect(rendered).to have_css(".arguments.contra")
  end
end
