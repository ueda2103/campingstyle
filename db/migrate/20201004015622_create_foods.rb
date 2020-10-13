class CreateFoods < ActiveRecord::Migration[5.2]
  def change
    create_table :foods do |t|
      t.integer   :recipe_id, null: false
      t.string    :name,      null: false

      t.timestamps
    end

    add_foreign_key :foods, :recipes
  end
end
