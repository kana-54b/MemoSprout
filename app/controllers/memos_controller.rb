class MemosController < ApplicationController
  before_action :require_login

  def new
    @memo = Memo.new
  end

  def confirm
    unless params[:memo].present? # memos/confirmに直接アクセスした場合の対応
      redirect_to new_memo_path, error: "このアクセスは正しくありません"
      return
    end

    @memo = current_user.memos.build(memo_params)
    if @memo.invalid? # バリデーションエラーがある場合
      flash.now[:error] = "必須項目を入力してください🙏"
      render :new, status: :unprocessable_entity
      return
    end
    render :confirm
  end

  def create
    @memo = current_user.memos.build(memo_params)
    if @memo.save
      redirect_to memos_path, success: "メモを保存しました✨"
    else
      flash.now[:error] = "メモの保存に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @latest_memo = current_user.memos.includes(:user).order(updated_at: :desc).first
    @memos = current_user.memos.order(created_at: :desc).page(params[:page]).per(10)
    @total_memos = @memos.total_count # Kaminariのtotal_countで全体数を取得
    @streak_days = Memo.streak_days(current_user) # 連続
    @today_memo = Memo.today_memo?(current_user) # 今日のメモが存在するか？
  end

  def show
    @memo = current_user.memos.find_by(id: params[:id])

    unless @memo
      redirect_to new_memo_path, error: "このアクセスは正しくありません🥶"
    end


    # Xシェア
    memo_data = JSON.parse(@memo.memo_content)
    what = memo_data["what"].gsub(/\R/, "") if memo_data["what"].present? # 改行を削除
    emotion = memo_data["emotion"]

    emoji = emotion ? { happy: "😀", angry: "😤", sad: "😞", funny: "😆", other: "😌" }[emotion.to_sym] || "✏️" : "✏️"

    # シェアテキストを生成
    @share_text = "#{emoji} : 「#{what}」について\n掘り下げて思考の芽を生やしました🌱\n#{root_url}\n#MemoSprout"
  end

  def edit
    @memo = current_user.memos.find_by(id: params[:id])

    unless @memo
      redirect_to new_memo_path, alert: "このアクセスは正しくありません😞"
    end
  end

  def update
    @memo = current_user.memos.find(params[:id])
    if @memo.update(memo_params)
      redirect_to memos_path, success: "メモを更新しました✨"
    else
      flash.now[:error] = "メモの編集に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @memo = current_user.memos.find_by(id: params[:id])
    if @memo.destroy!
    @total_memos = current_user.memos.count
    @streak_days = Memo.streak_days(current_user)
    @today_memo = Memo.today_memo?(current_user)
    end
  end

  private

  def not_authenticated
    redirect_to root_path, error: "ログインが必要です"
  end

  def memo_params
    params.require(:memo).permit(:emotion, :date, memo_content: [ :what, :why, :why_more, :how, :summary ])
  end
end
