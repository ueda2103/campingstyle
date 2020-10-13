class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.integer   :user_id,   null: false
      t.integer   :post_id
      t.integer   :recipe_id
      t.text      :body,      null: false

      t.timestamps
    end

    add_foreign_key :comments, :users
    add_foreign_key :comments, :posts
    add_foreign_key :comments, :recipes
  end
end
