require 'rails_helper'

RSpec.describe Memo, type: :model do
  include MemosHelper

  let(:user) { create(:user) }
  let(:memo) { build(:memo, user: user) } # 作成したユーザーに関連付けたメモを作成

  it "メモが作成できること" do
    expect(memo).to be_valid
  end

  it "memo_contentがないと無効であること" do
    memo.memo_content = nil
    expect(memo).not_to be_valid
    expect(memo.errors[:memo_content]).to include("を入力してください")
  end

  it "emotionがない場合も有効であること" do
    memo.emotion = nil
    expect(memo).to be_valid
  end

  it "各感情で正しく保存されること" do
    emotion_options.each do |emotion_key, emotion_value|
      memo = create(:memo, emotion: { emotion_key => [ emotion_value ] }.to_json)
      expect(memo.emotion).to eq({ emotion_key => [ emotion_value ] }.to_json)
    end
  end

  it "必須フィールドが不足しているとエラーになること" do
    memo.memo_content = { what: "何か" }.to_json
    expect(memo).not_to be_valid
    expect(memo.errors[:base]).to include("(*)は必須項目です")
  end

  # memo_contentのJSON形式への変換テスト
  it "memo_contentがハッシュ形式で渡された場合、JSON形式で保存されること" do
    hash_content ={ "what" => "何", "why" => "なぜ", "why_more" => "なぜ深掘り", "how" => "方法", "summary" => "まとめ" }
    memo.memo_content = hash_content
    expect(JSON.parse(memo.memo_content)).to eq(hash_content)
  end

  it "memo_contentが文字列形式で渡された場合、そのまま保存されること" do
    json_content = { what: "何" }.to_json
    memo.memo_content = json_content
    expect(memo.memo_content).to eq(json_content)
  end

  # favorited_by?メソッドのテスト
  describe "#favorited_by?" do
  context "ユーザーがお気に入り登録している場合" do
    let!(:memo_favorite) { create(:memo_favorite, memo: memo, user: user) }

    it "trueを返すこと" do
      expect(memo.favorited_by?(user)).to be_truthy
    end
  end

  context "ユーザーがお気に入り登録していない場合" do
    it "falseを返すこと" do
      expect(memo.favorited_by?(user)).to be_falsey # お気に入りは作成しない
    end
  end
end

  # streak_daysメソッドのテスト
  describe ".streak_days" do
    let!(:today_memo) { create(:memo, user: user, created_at: Date.today) }
    let!(:yesterday_memo) { create(:memo, user: user, created_at: Date.yesterday) }
    let!(:old_memo) { create(:memo, user: user, created_at: Date.today - 3.days) }

    it "連続記録が正しく計算されること" do
      expect(Memo.streak_days(user)).to eq(2) # 今日と昨日
    end

    it "連続記録が途切れている場合、正しく計算されること" do
      yesterday_memo.update(created_at: Date.today - 3.days) # 昨日のメモをさらに過去の日付に変更
      expect(Memo.streak_days(user)).to eq(1) # 今日のみ
    end
  end

  # today_memo?メソッドのテスト
  describe ".today_memo?" do
    it "今日のメモが存在する場合trueを返すこと" do
      create(:memo, user: user, created_at: Date.today)
      expect(Memo.today_memo?(user)).to be_truthy
    end

    it "今日のメモが存在しない場合falseを返すこと" do
      create(:memo, user: user, created_at: Date.yesterday)
      expect(Memo.today_memo?(user)).to be_falsey
    end
  end
end
