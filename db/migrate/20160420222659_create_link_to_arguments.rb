class CreateLinkToArguments < ActiveRecord::Migration[5.0]
  def change
    create_table :link_to_arguments do |t|
      t.references :statement, foreign_key: true
      t.integer :argument_id
      t.boolean :is_pro_argument, null: false

      t.timestamps
    end

    # Add an index to both statement_id and argument_id, for the purpose
    # of making sure a statement_id-argument_id-pair is uniqe.
    add_index :link_to_arguments, [:statement_id, :argument_id], unique: true
  end
end
