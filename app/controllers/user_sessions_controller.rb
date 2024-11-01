class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new; end

  def create # ログイン
    @user = login(params[:email], params[:password])

    if @user.save
      redirect_to memos_path(user_id: @user.id), success: "ログインしました"
    else
      redirect_to root_path, error: "ログインに失敗しました"
    end
  end

  def guest_login
    guest_user = User.create(
      first_name: "ゲスト",
      last_name: "ユーザー",
      email: "guest_#{SecureRandom.hex(8)}@example.com",
      password: "password",
      password_confirmation: "password"
    )
    Rails.logger.info("ゲストユーザーの情報:  #{guest_user.first_name} / #{guest_user.email} / #{guest_user.password} / #{guest_user.password_confirmation}")
    auto_login(guest_user)
    redirect_to memos_path(user_id: guest_user.id), success: "ゲストログインしました"
  end

  def destroy
    logout
    flash[:info] = "ログアウトしました。またね！"
    redirect_to root_path, status: :see_other
  end
end
