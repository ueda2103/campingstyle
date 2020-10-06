class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references  :user,    null: false, foreign_key: true
      t.references  :post,    foreign_key: true
      t.references  :recipe,  foreign_key: true
      t.text        :body,    null: false

      t.timestamps
    end
  end
end