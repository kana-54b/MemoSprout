class MemoFavorite < ApplicationRecord
  belongs_to :memo
  belongs_to :user

  validates :memo_id, uniqueness: { scope: :user_id } # 同じユーザーが同じメモを複数回お気に入り登録できない
end
