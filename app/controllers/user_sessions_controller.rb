class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new; end

  def create # ログイン
    @user = login(params[:email], params[:password])

    if @user && @user.save
      redirect_to memos_path, success: "ログインしました"
    else
      redirect_to root_path, error: "ログインに失敗しました"
    end
  end

  def guest_login
    User.where("email LIKE ?", "guest_%@example.com").where("created_at < ?", 24.hours.ago).destroy_all # 24時間前のゲストユーザーを削除

    guest_user = User.create(
      first_name: "ゲスト",
      last_name: "ユーザー",
      email: "guest_#{SecureRandom.hex(8)}@example.com",
      password: "password",
      password_confirmation: "password"
    )
    auto_login(guest_user)
    redirect_to memos_path(user_id: guest_user.id), success: "ゲストログインしました"
  end

  def destroy
    if current_user&.email&.start_with?("guest_") # ゲストユーザーの場合は削除
      current_user.destroy
    end
    logout
    flash[:info] = "ログアウトしました。またね！"
    redirect_to root_path, status: :see_other
  end
end
