require 'rails_helper'

RSpec.describe "Comments routes", type: :routing do
  it "routes POST comments_path to the comment controller's create action" do
    expect(post(comments_path)).to route_to("comments#create")
  end
end
