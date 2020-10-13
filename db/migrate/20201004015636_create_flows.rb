class CreateFlows < ActiveRecord::Migration[5.2]
  def change
    create_table :flows do |t|
      t.references  :recipe,    null: false, foreign_key: true
      t.string      :body,      null: false

      t.timestamps
    end
  end
end
