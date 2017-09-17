class AddScoreToStatementArgumentLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :statement_argument_links, :score, :decimal
  end
end
