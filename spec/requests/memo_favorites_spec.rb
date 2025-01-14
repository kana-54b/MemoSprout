require 'rails_helper'

RSpec.describe "MemoFavorites", type: :request do
  let(:user) { create(:user) }
  let(:memo) { create(:memo, user: user) }
  let(:memo_favorite) { create(:memo_favorite, memo: memo, user: user) }

  before do
    allow_any_instance_of(MemoFavoritesController).to receive(:current_user).and_return(user)
  end

  describe "POST /memo_favorites" do
    it "お気に入りを作成できること" do
      expect {
        post memo_favorites_path, params: { memo_id: memo.id }, as: :turbo_stream
      }.to change(MemoFavorite, :count).by(1)

      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE /memo_favorites/:id" do
    it "お気に入りを削除できること" do
      favorite = create(:memo_favorite, memo: memo, user: user)

      expect {
        delete memo_favorite_path(favorite), as: :turbo_stream
      }.to change(MemoFavorite, :count).by(-1)

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /memo_favorites" do
    it "お気に入り一覧が取得できること" do
      create(:memo_favorite, memo: memo, user: user)

      get memo_favorites_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include(memo.date.to_s)
      expect(response.body).to include(JSON.parse(memo.memo_content)["what"])
    end
  end
end