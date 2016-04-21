require 'rails_helper'

RSpec.describe "Statement routes", type: :routing do
  it "routes GET statements_path to the statements controller's index action" do
    expect(get(statements_path)).to route_to("statements#index")
  end

  it "routes GET root_path to the statements controller's index action" do
    expect(get(root_path)).to route_to("statements#index")
  end

  it "routes GET statement_path(:id) to the statements controller's show action" do
    expect(get(statement_path(id: 1))).to route_to(
      controller: "statements",
      action: "show",
      id: "1"
    )
  end
end
