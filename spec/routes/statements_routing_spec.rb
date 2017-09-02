require 'rails_helper'

RSpec.describe "Statement routes", type: :routing do
  it "routes GET statements_path to the statements controller's index action" do
    expect(get(statements_path)).to route_to("statements#index")
  end

  it "routes GET statements_path to the statements controller's index action" do
    expect(get(statements_path)).to route_to("statements#index")
  end

  it "routes GET statement_path(:id) to the statements controller's show action" do
    expect(get(statement_path(id: 1))).to route_to(
      controller: "statements",
      action: "show",
      id: "1"
    )
  end

  it "routes GET new_statement_path to the statements controller's new action" do
    expect(get(new_statement_path)).to route_to("statements#new")
  end

  it "routes POST statements_path to the statements controller's create action" do
    expect(post(statements_path)).to route_to("statements#create")
  end
end
