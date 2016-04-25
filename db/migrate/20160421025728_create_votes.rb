class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true
      t.references :voteable, polymorphic: true
      t.boolean :is_pro_vote, null: false

      t.timestamps
    end

    # Add an index to :user_id, :voteable_id and :voteable_type,
    # to make sure each user can only vote for a voteable once.
    add_index :votes, [:user_id, :voteable_id, :voteable_type], unique: true
  end
end
