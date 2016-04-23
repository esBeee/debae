class CreateStatementArgumentLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :statement_argument_links do |t|
      t.references :statement, foreign_key: true
      t.integer :argument_id
      t.boolean :is_pro_argument, null: false

      t.timestamps
    end

    # Add an index to both statement_id and argument_id, for the purpose
    # of making sure a statement_id-argument_id-pair is uniqe.
    add_index :statement_argument_links, [:statement_id, :argument_id], unique: true

    # Add an index for argument_id
    add_index :statement_argument_links, :argument_id

    # Add a foreign key for column argument_id
    add_foreign_key :statement_argument_links, :statements, column: :argument_id
  end
end
