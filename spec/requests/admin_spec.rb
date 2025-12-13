# frozen_string_literal: true

require "rails_helper"

RSpec.describe "管理画面", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }

  describe "一覧ページ" do
    context "管理者の場合" do
      before { sign_in_as(admin) }

      it "管理メニューと各リンクが表示されること" do
        get admin_root_path
        expect(response.body).to include("管理画面")
        expect(response.body).to include(admin_questions_path)
        expect(response.body).to include(admin_categories_path)
        expect(response.body).to include(root_path)
      end
    end

    context "一般ユーザーの場合" do
      before { sign_in_as(user) }

      it "404 Not Found が返る" do
        get admin_root_path
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインユーザーの場合" do
      before { sign_out }
      it "トップページにリダイレクトされる" do
        get admin_root_path
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
