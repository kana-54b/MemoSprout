class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def new; end

  def create
    @user = User.find_by(email: params[:email])
    @user.deliver_reset_password_instructions! if @user # 有効期限付きのリセットコードを生成。ユーザーが存在する場合にメールを送信
    redirect_to root_path, success: t(".email_sent") # 「パスワードリセットの手続きメールを送信しました。メールから手続きを行ってください。」
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token) # tokenが見つかり、有効であればユーザーを返す

    if @user.blank?
      flash[:error] = t(".invalid") # 「パスワードリセットのリンクが無効または期限切れです」
      redirect_to new_password_reset_path and return
    end
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)

    @user.password_confirmation = params[:user][:password_confirmation]

    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      flash.now[:error] = t(".no_change") # 「パスワードの変更がありませんでした。」
      render :edit, status: :unprocessable_entity
      return
    end

    if @user.change_password(params[:user][:password]) # パスワードリセットに使用したトークンを削除し、パスワードを更新する
      redirect_to root_path, success: t(".changed") # 「パスワードを変更しました。」
    else
      flash.now[:error] = t(".failed") # 「パスワードを変更できませんでした。」
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
