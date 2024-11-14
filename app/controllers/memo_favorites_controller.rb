class MemoFavoritesController < ApplicationController
  def create
    @memo = Memo.find(params[:memo_id])
    memo_favorite = MemoFavorite.new(memo_id: @memo.id, user_id: current_user.id)
    memo_favorite.save
    redirect_to memos_path
  end

  def destroy
    memo_favorite = MemoFavorite.find(params[:id])
    memo_favorite.destroy!
    redirect_to memos_path
  end

  def index # お気に入りしたメモ一覧
    @memo_favorites = current_user.memo_favorites.includes(:memo).order(memos: { created_at: :desc }).page(params[:page]).per(5)
  end
end
