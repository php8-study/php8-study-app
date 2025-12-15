# frozen_string_literal: true

# 未ログインユーザーは全てLPにリダイレクト。
# 権限違反・不正操作は一律で 404 を返す。

require "rails_helper"

RSpec.describe "Admin::Home", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }

  describe "GET /admin" do
    context "管理者としてアクセスした場合" do
      before { sign_in_as(admin) }

      it "正常にレスポンスが返る" do
        get admin_root_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("管理画面")
      end
    end

    context "一般ユーザーとしてアクセスした場合" do
      before { sign_in_as(user) }

      it "404 Not Found を返す" do
        get admin_root_path
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインユーザーとしてアクセスした場合" do
      it "ルートパスへリダイレクトされる" do
        get admin_root_path
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
