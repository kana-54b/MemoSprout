require 'rails_helper'

RSpec.describe Authentication, type: :model do
  it "ユーザーが関連づけられている場合は有効であること" do
    user = create(:user) # FactoryBotを使ってユーザーを作成
    authentication = Authentication.new(user: user)
    expect(authentication).to be_valid
  end

  it "ユーザーが設定されていない場合は無効であること" do
    authentication = Authentication.new(user: nil)
    expect(authentication).to_not be_valid
  end

  it "ユーザーに属している時は有効であること" do
    user = create(:user)
    authentication = create(:authentication, user: user)
    expect(authentication.user).to eq(user)
  end
end
