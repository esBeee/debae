require 'rails_helper'

RSpec.describe "Vote routes", type: :routing do
  it "routes POST votes_path(:statement_id) to the votes controller's create action" do
    expect(post(votes_path(statement_id: 1))).to route_to(
      controller: "votes",
      action: "create",
      statement_id: "1"
    )
  end
end
