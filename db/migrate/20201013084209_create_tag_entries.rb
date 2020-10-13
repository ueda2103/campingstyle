class CreateTagEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_entries do |t|
      t.integer   :tag_id,     null: false
      t.integer   :post_id
      t.integer   :recipe_id

      t.timestamps
    end

    add_foreign_key :tag_entries, :tags
    add_foreign_key :tag_entries, :posts
    add_foreign_key :tag_entries, :recipes
  end
end
