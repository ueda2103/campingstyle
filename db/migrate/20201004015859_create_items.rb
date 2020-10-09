class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.references    :user,      null: false, foreign_key: true
      t.string        :name,      null: false
      t.integer       :status,    null: false, default: 0

      t.timestamps
    end
  end
end
