class CreateMemoFavorites < ActiveRecord::Migration[7.2]
  def change
    create_table :memo_favorites do |t|
      t.references :memo, null: false, foreign_key: true

      t.timestamps
    end
    # memo_favoritesテーブルの memo_idカラムにユニーク制約を持たせた
    # インデックスを追加
    add_index :memo_favorites, :memo_id, unique: true
  end
end
