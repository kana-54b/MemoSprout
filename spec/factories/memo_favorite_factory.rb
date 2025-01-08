FactoryBot.define do
  factory :memo_favorite do
    association :memo # 関連するメモを自動的に作成
    association :user
  end
end