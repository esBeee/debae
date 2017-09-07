class AddScoresToStatements < ActiveRecord::Migration[5.1]
  def change
    add_column :statements, :argument_score, :decimal
    add_column :statements, :vote_score, :decimal
    add_column :statements, :amount_of_votes, :integer
  end
end
