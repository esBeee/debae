class AddEmailIfNewArgumentSettingToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :email_if_new_argument, :boolean, null: false, default: true
  end
end
