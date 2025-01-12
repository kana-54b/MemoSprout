require 'rails_helper'

RSpec.describe "Memos", type: :request do
  let(:user) { create(:user) }
  let(:memo) { create(:memo, user: user) }

  describe "GET /memos/new" do
    it "正常にメモ作成ページが表示されること" do
      get new_memo_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("メモを作成する")
    end
  end

  describe "POST /memos/confirm" do
    context "正常なデータの場合" do
      it "確認ページが表示されること" do
        post confirm_memos_path, params: { memo: attributes_for(:memo) }
        expect(response).to render_template(:confirm)
        expect(response).to have_http_status(:success)
      end
    end

    context "データが不正な場合" do
      it "エラーメッセージが表示されること" do
        post confirm_memos_path, params: { memo: { emotion: "" } }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST /memos" do
    context "正常なデータの場合" do
      it "メモが作成されること" do
        expect {
          post memos_path, params: { memo: attributes_for(:memo) }
        }.to change(Memo, :count).by(1)
        expect(response).to redirect_to(memos_path)
      end
    end

    context "データが不正な場合" do
      it "エラーメッセージが表示されること" do
        post memos_path, params: { memo: { emotion: "" } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET /memos" do
    it "メモ一覧ページが正常に表示されること" do
      get memos_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("メモ一覧")
    end

    it "メモの統計情報が表示されること" do
      create_list(:memo, 3, user: user)
      get memos_path
      expect(assigns(:total_memos)).to eq(3)
      expect(assigns(:streak_days)).to be_a(Integer)
      expect(assigns(:today_memo)).to be(false)
    end
  end

  describe "GET /memos/:id" do
    context "メモが存在する場合" do
      it "正しくメモ詳細ページが表示されること" do
        get memo_path(memo)
        expect(response).to have_http_status(:success)
        expect(response.body).to include(memo.memo_content["what"])
      end
    end

    context "メモが存在しない場合" do
      it "エラーメッセージが表示され、新規作成ページにリダイレクトされること" do
        get memo_path(999)
        expect(response).to redirect_to(new_memo_path)
        follow_redirect!
      end
    end
  end

  describe "PATCH /memos/:id" do
    context "更新が成功する場合" do
      it "メモが更新されること" do
        patch memo_path(memo), params: { memo: { emotion: "happy" } }
        expect(response).to redirect_to(memos_path)
        follow_redirect!
      end
    end

    context "更新が失敗する場合" do
      it "エラーメッセージが表示されること" do
        patch memo_path(memo), params: { memo: { emotion: "" } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE /memos/:id" do
    it "メモが削除されること" do
      delete memo_path(memo)
      expect(response).to have_http_status(:no_content)
      expect(Memo.exists?(memo.id)).to be_falsey
    end
  end
end
