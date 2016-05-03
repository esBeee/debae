class CreateStatements < ActiveRecord::Migration[5.0]
  def change
    create_table :statements do |t|
      t.references :user, foreign_key: true
      t.jsonb :body, null: false, default: '{}'
      t.decimal :score

      t.timestamps
    end
  end
end
