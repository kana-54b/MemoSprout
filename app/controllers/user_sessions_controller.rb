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

  def destroy
    logout
    flash[:info] = "ログアウトしました。またね！"
    redirect_to root_path, status: :see_other
  end
end
