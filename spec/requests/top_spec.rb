require 'rails_helper'

RSpec.describe "Top", type: :request do
  describe "GET /top/index" do
    it "正常にTopページが表示されること" do
      get top_index_path # HTTP Verb  path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("このアプリでできること")
    end

    it "正常にプライバシーポリシーページが表示されること" do
      get privacy_policy_path
      expect(response).to have_http_status(:ok)
    end

    it "正常に利用規約ページが表示されること" do
      get terms_of_service_path
      expect(response).to have_http_status(:ok)
    end
  end
end
