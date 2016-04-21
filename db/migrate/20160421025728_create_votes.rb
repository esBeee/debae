class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      # Index on user_id is not required since there currently seems to be no reason to
      # search for a users votes.
      t.references :user, index: false, foreign_key: true
      t.references :statement, foreign_key: true
      t.boolean :is_pro_vote, null: false

      t.timestamps
    end

    # Add an index to both statement_id and user_id, for the purpose
    # of making sure a statement_id-user_id-pair is uniqe.
    add_index :votes, [:statement_id, :user_id], unique: true
  end
end
