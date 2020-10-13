class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.references  :user,        null: false, foreign_key: true
      t.json        :post_images, null: false
      t.string      :title,       null: false
      t.text        :body,        null: false
      t.integer     :footprint,   null: false, default: 0

      t.timestamps
    end

    add_index :posts, [:title, :footprint]
  end
end
