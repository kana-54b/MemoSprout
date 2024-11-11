class CreateMemoFavorites < ActiveRecord::Migration[7.2]
  def change
    create_table :memo_favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :memo, null: false, foreign_key: true

      t.timestamps
    end
    add_index :memo_favorites, %i[user_id memo_id], unique: true
  end
end
