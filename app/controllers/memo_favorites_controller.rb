class MemoFavoritesController < ApplicationController
  def create
    memo = Memo.find(params[:memo_id])
    memo_favorite = MemoFavorite.new(memo_id: memo.id, user_id: current_user.id)

    if memo_favorite.save
      # 保存成功の処理
      redirect_to memos_path, success: "お気に入りに登録成功✨"
    else
      # 保存失敗の処理
      redirect_to memos_path, error: "お気に入りに登録失敗"
    end
  end

  def destroy
  end

  def index # お気に入りしたメモ一覧
    @memo_favorites = current_user.memo_favorites.includes(:memo).order(created_at: :desc).page(params[:page]).per(5)
  end
end
