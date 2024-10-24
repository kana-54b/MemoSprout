class MemosController < ApplicationController
  before_action :require_login, only: %i[new create]

  def new
    @memo = Memo.new
  end

  def confirm
    unless params[:memo].present? # memos/confirmに直接アクセスした場合の対応
      redirect_to new_memo_path, error: "フォームから入力してください"
      return
    end

    @memo = current_user.memos.build(memo_params)
    if @memo.invalid? # バリデーションエラーがある場合
      flash.now[:error] = "メモの作成に失敗しました😨"
      render :new, status: :unprocessable_entity
      return
    end
      Rails.logger.debug "confirmアクション Memo_params内容🎃🎃🎃: #{memo_params.inspect}" # デバッグ用ログ
      render :confirm
  end

  def create
    Rails.logger.debug "createアクション Memo_params内容🌱🌱🌱: #{memo_params.inspect}" # デバッグ用ログ
    @memo = current_user.memos.build(memo_params)
    if @memo.save
      redirect_to new_memo_path, success: "メモを作成しました"
    else
      flash.now[:error] = "メモの作成に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def not_authenticated; end

  def memo_params
    params.require(:memo).permit(:emotion, :date, memo_content: [ :what, :why, :why_more, :how, :summary ])
  end
end
