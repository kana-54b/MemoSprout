require 'rails_helper'

RSpec.describe "UserSessions", type: :request do
  let(:user) { create(:user, password: "password", password_confirmation: "password") }

  describe "GET /login" do
    describe "GET /login" do
      it "ログインフォームが正しく表示されること" do
        get login_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /login" do
    context "有効なパラメータの場合" do
      it "ログインに成功し、リダイレクトされること" do
        post login_path, params: { email: user.email, password: "password" }
        expect(response).to redirect_to(memos_path)
        follow_redirect!
        expect(response.body).to include("ログインしました")
      end
    end

    context "無効なパラメータの場合" do
      it "ログインに失敗し、リダイレクトされること" do
        post login_path, params: { email: user.email, password: "pass123" }
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("ログインに失敗しました")
      end
    end
  end

  describe "POST /guest_login" do
    it "ゲストログインが成功し、リダイレクトされること" do
      expect {
        post guest_login_path
      }.to change(User, :count).by(1)

      expect(response).to redirect_to memos_path
      follow_redirect!
      expect(response.body).to include("ゲストログインしました")
    end
  end

  describe "DELETE /logout" do
    context "通常ユーザーの場合" do
      it "ログアウトに成功し、リダイレクトされること" do
        post login_path, params: { email: user.email, password: "password" }
        delete logout_path
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("ログアウトしました。またね！")
      end
    end

    context "ゲストユーザーの場合" do
      it "ゲストユーザーが削除され、ログアウトに成功すること" do
        post guest_login_path
        expect(User.count).to eq(1)

        delete logout_path
        expect(User.count).to eq(0) # ゲストユーザーが削除されることを確認
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("ログアウトしました。またね！")
      end
    end
  end
end
