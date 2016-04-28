class AddProfileAttributesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string, null: false, default: "", limit: 70
    add_column :users, :avatar_url, :string, limit: 1000
  end
end
