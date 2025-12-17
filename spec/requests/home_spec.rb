# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Home", type: :request do
  describe "GET /" do
    context "未ログインの場合" do
      it "LP（ランディングページ）が表示される" do
        get root_path

        expect(response).to have_http_status(:ok)

        expect(response.body).to include("PHP8Study")
        expect(response.body).to include("初級試験対応")

        expect(response.body).not_to include("ダッシュボード")
        expect(response.body).not_to include("模擬試験を受験する")
      end
    end

    context "一般ユーザーでログインしている場合" do
      let(:user) { create(:user, admin: false) }
      before { sign_in_as(user) }

      it "ダッシュボード（一般用）が表示される" do
        get root_path

        expect(response).to have_http_status(:ok)

        expect(response.body).to include("ダッシュボード")
        expect(response.body).to include("ランダム問題を解く")

        expect(response.body).not_to include("管理画面")
      end
    end

    context "管理者でログインしている場合" do
      let(:admin) { create(:user, admin: true) }
      before { sign_in_as(admin) }

      it "ダッシュボード（管理者用）が表示される" do
        get root_path

        expect(response).to have_http_status(:ok)

        expect(response.body).to include("管理画面")
        expect(response.body).to include("ユーザー管理")
      end
    end
  end
end
