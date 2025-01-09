require 'rails_helper'

RSpec.describe MemoFavorite, type: :model do
  let(:user) { create(:user) }
  let(:memo) { create(:memo, user: user) }

  it "同じユーザーが同じメモを複数回お気に入り登録できないこと" do
    create(:memo_favorite, memo: memo, user: user) # 最初の登録
    memo_favorite_duplicate = build(:memo_favorite, memo: memo, user: user) # 重複登録を試みる

    expect(memo_favorite_duplicate).not_to be_valid
    expect(memo_favorite_duplicate.errors[:memo_id]).to include("はすでに存在します") # ユニーク制約エラー
  end

  it "メモが削除されるとお気に入りも削除されること" do
    memo_favorite = create(:memo_favorite, memo: memo, user: user)
    memo.destroy

    expect(MemoFavorite.exists?(memo_favorite.id)).to be_falsey # お気に入りも削除されていることを確認
  end

  it "memo_idとuser_idの組み合わせがユニークであること" do
    create(:memo_favorite, memo: memo, user: user)
    duplicate_favorite = build(:memo_favorite, memo: memo, user: user)

    expect(duplicate_favorite).not_to be_valid
    expect(duplicate_favorite.errors[:memo_id]).to include("はすでに存在します")
  end
end
