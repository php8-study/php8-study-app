# frozen_string_literal: true

require "rails_helper"

RSpec.describe "管理画面 カテゴリー", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let!(:category) { create(:category, name: "テストカテゴリー") }

  describe "管理者ユーザー" do
    before { sign_in_as(admin) }

    describe "一覧取得" do
      it "カテゴリー一覧ページが取得できること" do
        get admin_categories_path
        expect(response.body).to include("テストカテゴリー")
        expect(response.body).to include(new_admin_category_path)
        expect(response.body).to include(admin_root_path)
      end
    end

    describe "新規作成" do
      context "有効なパラメータの場合" do
        it "カテゴリーが作成される" do
          expect {
            post admin_categories_path, params: { category: { name: "新しいカテゴリー", chapter_number: 99, weight: 20 } }
          }.to change(Category, :count).by(1)

          follow_redirect!
          expect(response.body).to include("カテゴリーを作成しました")
          expect(response.body).to include("新しいカテゴリー")
        end
      end

      context "無効なパラメータの場合" do
        it "エラーで作成されない" do
          post admin_categories_path, params: { category: { name: "", chapter_number: "", weight: "" } }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("エラーがあります")
        end
      end
    end

    describe "編集" do
      context "有効なパラメータの場合" do
        it "カテゴリーが更新される" do
          patch admin_category_path(category), params: { category: { name: "編集後のカテゴリー" } }
          expect(response).to have_http_status(:ok)
          expect(category.reload.name).to eq("編集後のカテゴリー")
        end
      end

      context "無効なパラメータの場合" do
        it "更新されずエラーが返る" do
          patch admin_category_path(category), params: { category: { name: "" } }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(category.reload.name).to eq("テストカテゴリー")
        end
      end
    end

    describe "削除" do
      context "紐づく問題がない場合" do
        it "削除できる" do
          expect {
            delete admin_category_path(category)
          }.to change(Category, :count).by(-1)
        end
      end

      context "紐づく問題がある場合" do
        before { create(:question, category: category) }

        it "削除できずエラーになる" do
          expect {
            delete admin_category_path(category)
          }.not_to change(Category, :count)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("削除できません")
        end
      end
    end
  end

  describe "一般ユーザー" do
    before { sign_in_as(user) }

    it "一覧ページにアクセスすると404になる" do
      get admin_categories_path
      expect(response).to have_http_status(:not_found)
    end

    it "編集ページにアクセスすると404になる" do
      get edit_admin_category_path(category)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "非ログインユーザー" do
    it "一覧ページにアクセスするとrootにリダイレクトされる" do
      get admin_categories_path
      expect(response).to redirect_to(root_path)
    end

    it "編集ページにアクセスするとrootにリダイレクトされる" do
      get edit_admin_category_path(category)
      expect(response).to redirect_to(root_path)
    end
  end
end
