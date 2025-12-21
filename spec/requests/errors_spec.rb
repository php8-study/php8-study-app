# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Errors", type: :request do
  describe "404 Not Found" do
    it "存在しないパスにアクセスすると404ページが表示されること" do
      get "/non_existent_path"

      expect(response).to have_http_status(:not_found)
      expect(response.body).to include("ページが見つかりません")
      expect(response.body).to include("404")
    end
  end

  describe "500 Internal Server Error" do
    it "500ページが正しく表示されること" do
      get "/500"

      expect(response).to have_http_status(:internal_server_error)
      expect(response.body).to include("サーバーエラーが発生しました")
      expect(response.body).to include("500")
    end
  end
end
