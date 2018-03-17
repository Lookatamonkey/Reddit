class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.text :comment, null: false
      t.integer :sub_id, null: false
      t.integer :author_id, null: false

      t.timestamps
    end
    add_index :posts, :sub_id, unique: true
    add_index :posts, :author_id, unique: true
  end
end
