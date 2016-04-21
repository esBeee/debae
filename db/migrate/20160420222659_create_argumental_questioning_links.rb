class CreateArgumentalQuestioningLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :argumental_questioning_links do |t|
      t.references :statement, foreign_key: true
      t.integer :argument_id
      t.boolean :is_pro_argument, null: false

      t.timestamps
    end

    add_index :argumental_questioning_links, :argument_id
  end
end
