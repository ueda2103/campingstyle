class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.integer :user_id, null: false
      t.string  :name,    null: false
      t.integer :status,  null: false, default: 0

      t.timestamps
    end

    add_foreign_key :items, :users
  end
end
