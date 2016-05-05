class AddOmniauthToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :uids, :jsonb, null: false, default: "{}"

    # Add an index to all provider-uid-pairs to ensure uniqueness.
    execute <<-SQL
      CREATE UNIQUE INDEX facebook_uid_index ON users ((uids->>'facebook'));
      CREATE UNIQUE INDEX twitter_uid_index ON users ((uids->>'twitter'));
      CREATE UNIQUE INDEX google_oauth2_uid_index ON users ((uids->>'google_oauth2'));
    SQL
  end
end
