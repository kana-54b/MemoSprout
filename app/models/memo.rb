class Memo < ApplicationRecord
  belongs_to :user

  validates :memo_content, presence: true
  validate :validate_memo_content

  def validate_memo_content
    # memo_contentがJSON形式であることを前提にデータを取得
    data = JSON.parse(memo_content) rescue {}

    if data["what"].blank? || data["why"].blank? || data["why_more"].blank? || data["how"].blank? || data["summary"].blank?
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
