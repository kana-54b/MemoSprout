class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :memos, dependent: :destroy
  has_many :memo_favorites, through: :memos

  validates :email, presence: { message: "メールアドレスを入力してください" }, uniqueness: { message: "このメールアドレスはすでに使用されています" }
  validates :password, length: { minimum: 4, message: "パスワードは4文字以上にしてください" }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: { message: "確認用パスワードが一致していません" }, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: { message: "確認用パスワードを入力してください" }, if: -> { new_record? || changes[:crypted_password] }
  validates :first_name, presence: { message: "姓を入力してください" }
  validates :last_name, presence: { message: "名を入力してください" }
end
