require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users/new" do
    it "正常にユーザー登録ページが表示されること" do
      get new_user_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("ユーザー登録")
    end
  end

  describe "POST /users" do
    context "有効なパラメータの場合" do
      it "ユーザーが作成され、リダイレクトされること" do
        valid_params = {
          user: {
            email: "test@example.com",
            password: "password",
            password_confirmation: "password",
            first_name: "太郎",
            last_name: "山田"
          }
        }

        expect {
          post users_path, params: valid_params
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(memos_path)
        follow_redirect!
        expect(response.body).to include("ユーザー登録が完了しました")
      end
    end

    context "無効なパラメータの場合" do
      it "ユーザーが作成されず、エラーメッセージが表示されること" do
        invalid_params = {
          user: {
            email: "",
            password: "password",
            password_confirmation: "pass123",
            first_name: "",
            last_name: ""
          }
        }

        expect {
          post users_path, params: invalid_params
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("ユーザー登録ができませんでした")
      end
    end
  end
end
