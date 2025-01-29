require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  let(:user) { create(:user) }

  describe "GET /password_resets/new" do
    it "正常パスワード申請ページ（new）が表示されること" do
      get new_password_reset_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("パスワードリセット申請")
    end
  end

  describe "POST /password_resets" do
    context "有効なメールアドレスの場合" do
      it "パスワードリセットのメールが送信されること" do
        post password_resets_path, params: { email: user.email }
        expect(response).to redirect_to(root_path)
        expect(flash[:success]).to include("パスワードリセットの手続きメールを送信しました")
      end
    end

    context "存在しないメールアドレスの場合" do
      it "エラーメッセージは表示されない（セキュリティのため）" do
        post password_resets_path, params: { email: "not_user@example.com" }
        expect(response).to redirect_to(root_path)
        expect(flash[:success]).to include("パスワードリセットの手続きメールを送信しました")
      end
    end
  end

  describe "GET /password_resets/:id/edit" do
    let(:token) do
      user.deliver_reset_password_instructions! # 戻り値はトークンではなくメールオブジェクト
      user.reload.reset_password_token
    end

    context "有効なトークンの場合" do
      it "編集ページが正しく表示されること" do
        puts User.load_from_reset_password_token(token)
        get edit_password_reset_path(token)
        expect(response).to have_http_status(:success)
      end
    end

    context "無効なトークンの場合" do
      it "エラーメッセージが表示され、リダイレクトされること" do
        get edit_password_reset_path("invalid_token")
        expect(response).to redirect_to(new_password_reset_path)
        follow_redirect!
        expect(response.body).to include("パスワードリセットのリンクが無効または期限切れです")
      end
    end
  end

  let(:user) { create(:user, reset_password_token: SecureRandom.urlsafe_base64, reset_password_token_expires_at: 1.hour.from_now) }
  let(:token) { user.reset_password_token }

  it "有効なトークンと正しいパスワードの場合 パスワードが変更できること" do
    patch password_reset_path(token), params: {
      user: { password: "password2", password_confirmation: "password2" }
    }
    follow_redirect!
    expect(response.body).to include("パスワードを変更しました")
  end

  context "パスワードと確認用パスワードが一致しない場合" do
    it "パスワードの変更に失敗すること" do
      patch password_reset_path(token), params: {
        user: { password: "password", password_confirmation: "XXXpassword" }
      }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("パスワードを変更できませんでした")
    end
  end

  context "パスワードが未入力の場合" do
    it "エラーメッセージが表示されること" do
      patch password_reset_path(token), params: {
        user: { password: "", password_confirmation: "" }
      }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("パスワードの変更がありませんでした")
    end
  end
end
