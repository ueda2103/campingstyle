class CreateFoods < ActiveRecord::Migration[5.2]
  def change
    create_table :foods do |t|
      t.references  :recipe,    null: false, foreign_key: true
      t.string      :name,      null: false

      t.timestamps
    end
  end
end
