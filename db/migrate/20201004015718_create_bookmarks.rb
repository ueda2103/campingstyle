class CreateBookmarks < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarks do |t|
      t.integer   :user_id,   null: false
      t.integer   :post_id
      t.integer   :recipe_id
      
      t.timestamps
    end

    add_foreign_key :bookmarks, :users
    add_foreign_key :bookmarks, :posts
    add_foreign_key :bookmarks, :recipes
  end
end
