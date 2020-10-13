class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer   :user_id,        null: false
      t.json      :post_images, null: false
      t.string    :title,       null: false
      t.text      :body,        null: false
      t.integer   :footprint,   null: false, default: 0

      t.timestamps
    end

    add_index :posts, [:title, :footprint]
    add_foreign_key :posts, :users
  end
end
