require 'rails_helper'

RSpec.describe "statements/show.html.erb", type: :view do
  let(:statement) { FactoryGirl.build_stubbed(:statement, score: 0.351) }

  before do
    assign(:statement, statement)
    render
  end

  it "displays the statements body as <h1>" do
    expect(rendered).to have_css("h1", text: statement.body)
  end

  it "displays container for pro arguments" do
    expect(rendered).to have_css(".arguments.pro")
  end

  it "displays container for contra arguments" do
    expect(rendered).to have_css(".arguments.contra")
  end

  it "displays the statements score" do
    expect(rendered).to have_content("35 %")
  end

  it "displays headline for pro arguments" do
    expect(rendered).to have_content(I18n.t("statements.show.headlines.pro_arguments"))
  end

  it "displays headline for contra arguments" do
    expect(rendered).to have_content(I18n.t("statements.show.headlines.contra_arguments"))
  end
end
