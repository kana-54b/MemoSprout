class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :memos, dependent: :destroy
  has_many :memo_favorites, through: :memos
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  validates :email, presence: { message: "メールアドレスを入力してください" }, uniqueness: { message: "このメールアドレスはすでに使用されています" }
  validates :password, length: { minimum: 4, message: "パスワードは4文字以上にしてください" }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: { message: "確認用パスワードが一致していません" }, if: -> { new_record? || changes[:crypted_password] }
  validate :first_name_or_last_name_present

  def favorite_memo?(memo)
    memo_favorites.exists?(memo_id: memo.id) # memo_idが存在するか？
  end

  private

  def first_name_or_last_name_present
    if first_name.blank? && last_name.blank?
      errors.add(:base, "姓もしくは名のどちらかの入力は必須です")
    end
  end
end
