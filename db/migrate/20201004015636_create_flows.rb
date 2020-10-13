class CreateFlows < ActiveRecord::Migration[5.2]
  def change
    create_table :flows do |t|
      t.integer   :recipe_id,   null: false
      t.string    :body,        null: false

      t.timestamps
    end

    add_foreign_key :flows, :recipes
  end
end
