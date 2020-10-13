class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.integer   :user_id,   null: false
      t.integer   :post_id
      t.integer   :recipe_id

      t.timestamps
    end

    add_foreign_key :favorites, :users
    add_foreign_key :favorites, :posts
    add_foreign_key :favorites, :recipes
  end
end
