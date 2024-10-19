class Memo < ApplicationRecord
  belongs_to :user

  validates :emotion, presence: true
  validates :memo_content, presence: true
  validate :validate_memo_content

  def validate_memo_content
    data = memo_content
    if data["what"].blank? || data["why"].blank? || data["why_more"].blank? || data["how"].blank?
      errors.add(:base, "(*)は必須項目です")
    end
  end

  def memo_content=(value) # memo_contentデータの作成前にJSON形式に変換
    if value.is_a?(Hash)
      super(value.to_json)
    else
      super
    end
  end
end