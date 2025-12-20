# frozen_string_literal: true

# Admin::Categories は管理者専用。
# 未ログインユーザーは全てLPにリダイレクト。
# 権限違反・不正操作は一律で 404 を返す。
# 管理者の操作ミスのみ 422 を返す。

require "rails_helper"

RSpec.describe "Admin::Categories", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let!(:category) { create(:category, name: "既存カテゴリー", chapter_number: 1, weight: 10.0) }

  describe "GET /admin/categories" do
    context "管理者としてアクセスした場合" do
      before { sign_in_as(admin) }

      it "正常にレスポンスが返る" do
        get admin_categories_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "一般ユーザーの場合" do
      before { sign_in_as(user) }
      it "404 Not Found になる" do
        get admin_categories_path
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインの場合" do
      it "ログイン画面等へリダイレクトされる" do
        get admin_categories_path
        expect(response).to redirect_to(root_path)
      end
    end
  end


  describe "GET /admin/categories/new" do
    context "管理者としてアクセスした場合" do
      before { sign_in_as(admin) }

      it "正常にレスポンスが返る" do
        get new_admin_category_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "一般ユーザーの場合" do
      before { sign_in_as(user) }
      it "404 Not Found になる" do
        get new_admin_category_path
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインの場合" do
      it "ログイン画面等へリダイレクトされる" do
        get new_admin_category_path
        expect(response).to redirect_to(root_path)
      end
    end
  end


  describe "POST /admin/categories" do
    let(:valid_params) { { category: { name: "新カテゴリー", chapter_number: 2, weight: 20 } } }
    let(:invalid_params) { { category: { name: "", chapter_number: "invalid", weight: -1 } } }

    context "管理者としてアクセスした場合" do
      before { sign_in_as(admin) }

      context "有効なパラメータの場合" do
        it "カテゴリーが作成され、一覧へリダイレクトする" do
          expect {
            post admin_categories_path, params: valid_params
          }.to change(Category, :count).by(1)

          expect(response).to redirect_to(admin_categories_path)
          follow_redirect!
          expect(response.body).to include("カテゴリーを作成しました")
        end
      end

      context "無効なパラメータの場合（異常系）" do
        it "作成されず、422 Unprocessable Entity が返る" do
          expect {
            post admin_categories_path, params: invalid_params
          }.not_to change(Category, :count)

          expect(response).to have_http_status(:unprocessable_content)
        end
      end
    end

    context "一般ユーザーの場合" do
      before { sign_in_as(user) }
      it "作成されず、404 Not Found になる" do
        expect {
          post admin_categories_path, params: valid_params
        }.not_to change(Category, :count)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインの場合" do
      it "作成されず、ログイン画面等へリダイレクトされる" do
        expect {
          post admin_categories_path, params: valid_params
        }.not_to change(Category, :count)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /admin/categories/:id/edit" do
    context "管理者としてアクセスした場合" do
      before { sign_in_as(admin) }

      it "正常にレスポンスが返る" do
        get edit_admin_category_path(category)
        expect(response).to have_http_status(:ok)
      end

      context "存在しないIDを指定した場合" do
        it "404 Not Found になる" do
          get edit_admin_category_path(0)
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "一般ユーザーの場合" do
      before { sign_in_as(user) }
      it "404 Not Found になる" do
        get edit_admin_category_path(category)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインの場合" do
      it "ログイン画面等へリダイレクトされる" do
        get edit_admin_category_path(category)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /admin/categories/:id/" do
    context "管理者としてアクセスした場合" do
      before { sign_in_as(admin) }

      it "指定したカテゴリーのパーシャルHTMLが返る" do
        get admin_category_path(category)
        expect(response).to have_http_status(:ok)

        expect(response.body).to include(%(id="category_#{category.id}"))
        expect(response.body).to include(category.name)
      end

      context "存在しないIDを指定した場合" do
        it "404 Not Found になる" do
          get admin_category_path(0)
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "一般ユーザーの場合" do
      before { sign_in_as(user) }
      it "404 Not Found になる" do
        get admin_category_path(category)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインの場合" do
      it "ログイン画面等へリダイレクトされる" do
        get admin_category_path(category)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /admin/categories/:id" do
    let(:update_params) { { category: { name: "更新後の名前", weight: 50 } } }
    let(:invalid_update_params) { { category: { name: "", weight: 101 } } }

    context "管理者としてアクセスした場合" do
      before { sign_in_as(admin) }

      context "有効なパラメータの場合" do
        it "更新に成功し、Turbo Streamで置換処理が返る" do
          patch admin_category_path(category), params: update_params, as: :turbo_stream

          expect(response).to have_http_status(:ok)
          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(category.reload.name).to eq "更新後の名前"

          expect(response.body).to include('<turbo-stream action="replace"')
          expect(response.body).to include(%(target="category_#{category.id}"))
          expect(response.body).to include("更新後の名前")
        end
      end

      context "無効なパラメータの場合（異常系）" do
        it "更新されず、422 Unprocessable Entity が返る" do
          patch admin_category_path(category), params: invalid_update_params

          expect(response).to have_http_status(:unprocessable_content)
          expect(category.reload.name).to eq "既存カテゴリー"
        end
      end

      context "存在しないIDを指定した場合" do
        it "404 Not Found になる" do
          patch admin_category_path(0), params: update_params
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "一般ユーザーの場合" do
      before { sign_in_as(user) }
      it "更新されず、404 Not Found になる" do
        patch admin_category_path(category), params: update_params
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインの場合" do
      it "更新されず、ログイン画面等へリダイレクトされる" do
        patch admin_category_path(category), params: update_params
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE /admin/categories/:id" do
    context "管理者としてアクセスした場合" do
      before { sign_in_as(admin) }

      context "削除可能な場合（問題が紐付いていない）" do
        it "削除に成功し、Turbo Streamレスポンスが返る" do
          delete admin_category_path(category), as: :turbo_stream

          expect(response).to have_http_status(:ok)
          expect(Category.exists?(category.id)).to be_falsey

          expect(response.body).to include(%(action="remove"))
          expect(response.body).to include(%(target="category_#{category.id}"))
        end
      end

      context "削除不可の場合（問題が紐付いている - 異常系）" do
        before do
          create(:question, category: category)
        end

        it "削除されず、422 Unprocessable Entity (Turbo Stream) が返る" do
          delete admin_category_path(category), as: :turbo_stream

          expect(response).to have_http_status(:unprocessable_content)
          expect(Category.exists?(category.id)).to be_truthy

          expect(response.body).to include("紐付く問題が存在します")
          expect(response.body).to include(%(action="update"))
          expect(response.body).to include(%(target="flash"))
        end
      end

      context "存在しないIDを指定した場合" do
        it "404 Not Found になる" do
          delete admin_category_path(0), as: :turbo_stream
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "一般ユーザーの場合" do
      before { sign_in_as(user) }
      it "削除されず、404 Not Found になる" do
        delete admin_category_path(category)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインの場合" do
      it "削除されず、ログイン画面等へリダイレクトされる" do
        delete admin_category_path(category)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
