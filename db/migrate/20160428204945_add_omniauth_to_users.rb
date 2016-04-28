class AddOmniauthToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string

    # Add an index to :provider, :uid to ensure the uniqueness.
    add_index :users, [:provider, :uid], unique: true
  end
end
