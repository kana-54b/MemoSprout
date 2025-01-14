class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :memos, dependent: :destroy
  has_many :memo_favorites, through: :memos
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: :invalid }
  validates :email, presence: { message: :blank }, uniqueness: { message: :taken } # 「を入力してください」「は既に使用されています」
  validates :password, length: { minimum: 4, message: :too_short }, if: -> { new_record? || changes[:crypted_password] } # 「は%{}文字以上で入力してください」
  validates :password, confirmation: { message: :confirmation }, if: -> { new_record? || changes[:crypted_password] } # 「…が一致しません」
  validate :first_name_or_last_name_present

  def favorite_memo?(memo)
    memo_favorites.exists?(memo_id: memo.id) # memo_idが存在するか？
  end

  private

  def first_name_or_last_name_present
    if first_name.blank? && last_name.blank?
      errors.add(:base, :blank_names) # 「姓もしくは名のどちらかの入力は必須です」
    end
  end
end
