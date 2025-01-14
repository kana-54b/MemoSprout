require 'rails_helper'

RSpec.describe "Oauths", type: :request do
  describe "GET /oauth/callback" do
    let(:provider) { "google" }

    context "ユーザーが見つからない場合" do
      before do
        allow_any_instance_of(OauthsController).to receive(:login_from).with(provider).and_return(nil)
      end

      it "外部認証プロバイダーにリダイレクトされること" do
        get oauth_callback_path, params: { provider:, code: "test123" }
        expect(response).to have_http_status(:redirect)
      end
    end

    context "ユーザーが認証をキャンセルした場合" do
      it "トップページにリダイレクトされ、適切なメッセージが表示されること" do
        get oauth_callback_path, params: { provider:, error: "access_denied" }
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Googleアカウントでのログインがキャンセルされました")
      end
    end

    context "既存のユーザーがログインできる場合" do
      let(:user) { create(:user) }

      before do
        allow_any_instance_of(OauthsController).to receive(:login_from).with(provider).and_return(user)
      end

      it "メモ一覧ページにリダイレクトされること" do
        get oauth_callback_path, params: { provider: }
        expect(response).to redirect_to(memos_path)
      end
    end

    context "新規ユーザーが作成される場合" do
      let(:user) { create(:user) }

      before do
        allow_any_instance_of(OauthsController).to receive(:login_from).with(provider).and_return(nil)
        allow_any_instance_of(OauthsController).to receive(:create_from).with(provider).and_return(user)
      end

      it "メモ一覧ページにリダイレクトされること" do
        get oauth_callback_path, params: { provider: }
        expect(response).to redirect_to(memos_path)
        follow_redirect!
        expect(response.body).to include("Googleアカウントでログインしました")
      end
    end

    context "新規ユーザー作成に失敗した場合" do
      before do
        allow_any_instance_of(OauthsController).to receive(:login_from).with(provider).and_return(nil)
        allow_any_instance_of(OauthsController).to receive(:create_from).with(provider).and_raise(StandardError, "エラー")
      end

      it "トップページにリダイレクトされること" do
        get oauth_callback_path, params: { provider: }
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Googleアカウントでのログインに失敗しました: エラー")
      end
    end
  end
end
