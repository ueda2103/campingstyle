class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.references    :followed,    null: false, foreign_key: {to_table: :users}
      t.references    :follower,    null: false, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
