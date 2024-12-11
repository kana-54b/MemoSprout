class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]

    # ユーザーが認証をキャンセルした場合
    if params[:error]
      redirect_to root_path, info: "#{provider.titleize}アカウントでのログインがキャンセルされました"
      return
    end

    # ユーザーが認証を許可した場合
    if (@user = login_from(provider))
      redirect_to memos_path, success: "#{provider.titleize}アカウントでログインしました"
    else
      begin
        @user = create_from(provider)
        reset_session # protect from session fixation attack（セッション固定攻撃から保護する）
        auto_login(@user)
        redirect_to memos_path, success: "#{provider.titleize}アカウントでログインしました"
      rescue StandardError => e
        flash[:error] = "#{provider.titleize}アカウントでのログインに失敗しました: #{e.message}"
        redirect_to root_path
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider, :error)
  end

  def signup_and_login(provider)
    @user = create_from(provider)
    reset_session
    auto_login(@user)
  end
end
