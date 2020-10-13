class CreateTagEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_entries do |t|
      t.references    :tag,     null: false, foreign_key: true
      t.references    :post,    foreign_key: true
      t.references    :recipe,  foreign_key: true

      t.timestamps
    end
  end
end
