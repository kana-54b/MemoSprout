require 'rails_helper'

RSpec.describe "Memos", type: :request do
  let(:user) { create(:user) }
  let(:memo) { create(:memo, user: user, emotion: "funny") }

  # ログイン状態を作成
  before do
    allow_any_instance_of(MemosController).to receive(:current_user).and_return(user)
  end

  describe "GET /new" do
    it "正常にメモ作成ページが表示されること" do
      get new_memo_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /memos/confirm" do
    context "正常なデータの場合" do
      it "確認ページが表示されること" do
        memo = create(:memo, user: user)  # memoを作成

        params = {
          emotion: memo.emotion,
          date: memo.date,
          memo_content: JSON.parse(memo.memo_content)
        }
        post confirm_memos_path, params: { memo: params }
        expect(response).to render_template(:confirm)
        expect(response).to have_http_status(:success)
      end
    end

    context "データが不正な場合" do
      it "エラーメッセージが表示されること" do
        post confirm_memos_path, params: { memo: { what: "" } }
        expect(response.body).to include("必須項目を入力してください🙏")
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
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
          post memos_path, params: { memo: { what: "" } }
          expect(response.body).to include("メモの保存に失敗しました")
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
        # 昨日の日付でmemoを作成
        create_list(:memo, 3, user: user, created_at: Date.yesterday)
        get memos_path
        expect(assigns(:total_memos)).to eq(3)
        expect(assigns(:streak_days)).to be_a(Integer)
        expect(assigns(:today_memo)).to be(false)
      end
    end

    describe "PATCH /memos/:id" do
      context "更新が成功する場合" do
        it "メモが更新されること" do
          patch memo_path(memo), params: { memo: { emotion: "other" } }
          expect(response).to redirect_to(memos_path)
          follow_redirect!
          expect(response.body).to include("メモを更新しました✨")
        end
      end
    end

    describe "DELETE /memos/:id" do
      it "メモが削除されること" do
        delete memo_path(memo)
        expect(Memo.exists?(memo.id)).to be_falsey
      end
    end
  end
end
