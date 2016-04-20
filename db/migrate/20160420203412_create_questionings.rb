class CreateQuestionings < ActiveRecord::Migration[5.0]
  def change
    create_table :questionings do |t|
      t.references :user, foreign_key: true
      t.text :body, null: false, limit: 260

      t.timestamps
    end
  end
end
