class RemoveDuplicateIndexesFromMemoFavorites < ActiveRecord::Migration[8.0]
  def change
    remove_index :memo_favorites, name: "index_memo_favorites_on_memo_id", column: :memo_id
    remove_index :memo_favorites, name: "index_memo_favorites_on_user_id", column: :user_id
  end
end
