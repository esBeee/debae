require 'rails_helper'

RSpec.describe "statements/new", type: :view do
  let(:statement) { Statement.new }

  before do
    assign(:statement, statement)
    render
  end

  it "renders an input field for the body" do
    expect(rendered).to have_field(I18n.t("statements.new.body"))
  end

  it "renders a hidden field to transport the potential argument_for parameter" do
    expect(rendered).to include('<input type="hidden" name="argument[argument_for]" id="argument_argument_for" />')
  end

  it "renders a hidden field to transport the potential is_pro_argument parameter" do
    expect(rendered).to include('<input type="hidden" name="argument[is_pro_argument]" id="argument_is_pro_argument" />')
  end
end
