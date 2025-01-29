require 'rails_helper'

RSpec.describe User, type: :model do
  it "姓or名、メール、パスワードがあれば有効であること" do
    user = build(:user) # FactoryBotを使用してユーザーを生成
    expect(user).to be_valid
  end

  it "姓と名のどちらも無ければ無効であること" do
    user = build(:user, first_name: nil, last_name: nil)
    expect(user).not_to be_valid
    expect(user.errors[:base]).to include("姓もしくは名のどちらかは入力必須です")
  end

  it "メールアドレスが無ければ無効な状態であること" do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("を入力してください")
  end

  it "重複したメールアドレスは無効な状態であること" do
    create(:user, email: "test@example.com") # 1つ目のユーザーを作成
    user = build(:user, email: "test@example.com") # 同じメールで2つ目を生成
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("はすでに存在します")
  end

  it "3文字以下のパスワードは無効であること" do
    user = build(:user, password: "abc", password_confirmation: "abc")
    expect(user).not_to be_valid
    expect(user.errors[:password]).to include("は4文字以上で入力してください")
  end

  it "4文字以上のパスワードは有効であること" do
    user = build(:user, password: "abcd", password_confirmation: "abcd")
    expect(user).to be_valid
  end

  it "パスワードとパスワード確認が一致しなければ無効であること" do
    user = build(:user, password: "password", password_confirmation: "passwo")
    expect(user).not_to be_valid
    expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
  end

  describe "#favorite_memo?" do
    let(:user) { create(:user) } # FactoryBotでユーザーを作成
    let(:memo) { create(:memo, user: user) } # FactoryBotでメモを作成

    context "お気に入り登録されている場合" do
      before do
        create(:memo_favorite, memo: memo, user: user) # お気に入り登録
      end

      it "trueを返すこと" do
        expect(user.favorite_memo?(memo)).to be_truthy
      end
    end

    context "お気に入り登録されていない場合" do
      it "falseを返すこと" do
        expect(user.favorite_memo?(memo)).to be_falsey
      end
    end
  end
end
