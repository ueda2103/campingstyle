class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.integer   :user_id,       null: false
      t.json      :recipe_images, null: false
      t.string    :title,         null: false
      t.text      :body,          null: false
      t.integer   :status,        null: false, default: 0
      t.integer   :footprint,     null: false, default: 0

      t.timestamps
    end

    add_index :recipes, [:title, :footprint]
    add_foreign_key :recipes, :users
  end
end
