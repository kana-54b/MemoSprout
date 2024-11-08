class MemoFavorite < ApplicationRecord
  belongs_to :memo

  validates :memo_id, uniqueness: true

  def add_memo_favorite(memo) # お気に入り登録
    self.class.create(memo: memo) # MemoFavoriteの新しいインスタンスを作成
  end

  def remove_memo_favorite(memo) # お気に入り解除
    self.class.find_by(memo: memo)&.destroy
  end

  def memo_favorite?(memo) # お気に入りしたメモかどうか
    self.class.exists?(memo: memo)
  end
end
