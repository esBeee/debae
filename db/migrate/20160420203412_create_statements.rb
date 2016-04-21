class CreateStatements < ActiveRecord::Migration[5.0]
  def change
    create_table :statements do |t|
      t.references :user, foreign_key: true
      t.string :body, null: false, limit: 260

      t.timestamps
    end
  end
end
