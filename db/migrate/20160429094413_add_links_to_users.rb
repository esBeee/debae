class AddLinksToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :link_to_facebook, :string, limit: 100
    add_column :users, :link_to_twitter, :string, limit: 100
    add_column :users, :link_to_google_plus, :string, limit: 100
  end
end
