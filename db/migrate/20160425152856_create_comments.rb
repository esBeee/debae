class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.references :commentable, polymorphic: true
      t.references :user, foreign_key: true
      t.integer :related_comment_id

      t.timestamps
    end

    # Add an index for related_comment_id
    add_index :comments, :related_comment_id

    # Add a foreign key constraint for column related_comment_id
    add_foreign_key :comments, :comments, column: :related_comment_id
  end
end
