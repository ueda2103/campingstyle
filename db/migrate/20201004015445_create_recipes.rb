class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.references  :user,          null: false, foreign_key: true
      t.json        :recipe_images, null: false
      t.string      :title,         null: false
      t.text        :body,          null: false
      t.boolean     :status,        null: false, default: false
      t.integer     :footprint,     null: false, default: 0

      t.timestamps
    end

    add_index :recipes, [:title, :footprint]
  end
end
