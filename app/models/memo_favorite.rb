class MemoFavorite < ApplicationRecord
  belongs_to :memo

  validates :memo_id, uniquness: true
end
