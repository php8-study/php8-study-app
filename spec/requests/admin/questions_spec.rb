# frozen_string_literal: true

# Admin::Questions は管理者専用。
# 権限違反・不正操作は一律で 404 を返す。
# 管理者の操作ミスのみ 422 を返す。

require "rails_helper"

RSpec.describe "Admin::Questions", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let(:category) { create(:category) }

  let!(:question) { create(:question, category: category, content: "試験使用前問題") }
  let!(:in_use_question) { create(:question, :in_use, category: category, content: "試験使用中問題") }
  let!(:archived_question) { create(:question, :archived, category: category, content: "論理削除済問題") }


  describe "GET /admin/questions" do
    context "管理者としてアクセスした場合" do
      before { sign_in_as(admin) }

      it "正常にレスポンスが返り、有効な問題のみが表示される" do
        get admin_questions_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("試験使用前問題")
        expect(response.body).to include("試験使用中問題")
      
        expect(response.body).not_to include("論理削除済問題")
      end
    end

    context "一般ユーザーの場合" do
      before { sign_in_as(user) }
      it "404 Not Found になる" do
        get admin_questions_path
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインの場合" do
      it "ランディングページへリダイレクトされる" do
        get admin_questions_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /admin/questions/new" do
    context "管理者としてアクセスした場合" do
      before { sign_in_as(admin) }

      it "正常にレスポンスが返る" do
        get new_admin_question_path
        expect(response).to have_http_status(:ok)
      end
    end
    
    context "一般ユーザーの場合" do
      before { sign_in_as(user) }
      it "404 Not Found になる" do
        get new_admin_question_path
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインの場合" do
      it "ランディングページへリダイレクトされる" do
        get new_admin_question_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /admin/questions" do
    let(:valid_params) do
      { 
        question: { 
          content: "新規問題文", 
          category_id: category.id,
          explanation: "解説",
          question_choices_attributes: [
            { content: "選択肢1", correct: true },
            { content: "選択肢2", correct: false }
          ]
        } 
      }
    end

    let(:invalid_params) { { question: { content: "", category_id: category.id } } }

    context "管理者としてアクセスした場合" do
      before { sign_in_as(admin) }

      context "有効なパラメータの場合" do
        it "問題が作成され、一覧へリダイレクトする" do
          expect {
            post admin_questions_path, params: valid_params
          }.to change(Question, :count).by(1)

          expect(response).to redirect_to(admin_questions_path)
        end
      end

      context "無効なパラメータの場合" do
        it "作成されず、422 Unprocessable Entity が返る" do
          expect {
            post admin_questions_path, params: invalid_params
          }.not_to change(Question, :count)

          expect(response).to have_http_status(:unprocessable_content)
        end
      end
    end

    context "一般ユーザーの場合" do
      before { sign_in_as(user) }
      it "作成されず、404 Not Found になる" do
        expect {
          post admin_questions_path, params: valid_params
        }.not_to change(Question, :count)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /admin/questions/:id/edit" do
    context "管理者としてアクセスした場合" do
      before { sign_in_as(admin) }

      it "有効な問題であれば正常に表示される" do
        get edit_admin_question_path(question)
        expect(response).to have_http_status(:ok)
      end

      context "論理削除済みのIDを指定した場合" do
        it "404 Not Found になる" do
          get edit_admin_question_path(archived_question)
          expect(response).to have_http_status(:not_found)
        end
      end

      context "存在しないIDを指定した場合" do
        it "404 Not Found になる" do
          get edit_admin_question_path(0)
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "一般ユーザーの場合" do
      before { sign_in_as(user) }
      it "404 Not Found になる" do
        get edit_admin_question_path(question)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインの場合" do
      it "ランディングページへリダイレクトされる" do
        get edit_admin_question_path(question)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /admin/questions/:id" do
    let(:update_params) { { question: { category_id: category.id, content: "更新後の問題文" } } }
    let(:invalid_update_params) { { question: { content: "" } } }

    context "管理者としてアクセスした場合" do
      before { sign_in_as(admin) }

      context "未使用の問題を更新する場合（通常更新）" do
        it "レコード数は増えず、自身の属性が更新され、自身の編集画面へリダイレクトする" do
          expect {
            patch admin_question_path(question), params: update_params
          }.not_to change(Question, :count)

          question.reload
          expect(question.content).to eq "更新後の問題文"
          expect(question.deleted_at).to be_nil

          expect(response).to redirect_to(edit_admin_question_path(question))
        end
      end

      context "使用中の問題を更新する場合（バージョン管理更新）" do
        it "新しいレコードが作成され、新しい問題の編集画面へリダイレクトする" do
          expect {
            patch admin_question_path(in_use_question), params: update_params
          }.to change(Question, :count).by(1)

          expect(in_use_question.reload.deleted_at).to be_present

          new_question = Question.last
          expect(new_question.content).to eq "更新後の問題文"
          expect(new_question.id).not_to eq in_use_question.id

          expect(response).to redirect_to(edit_admin_question_path(new_question))
        end
      end

      context "無効なパラメータの場合" do
        it "更新されず、422 が返る" do
          patch admin_question_path(question), params: invalid_update_params
          expect(response).to have_http_status(:unprocessable_content)
          expect(question.reload.content).to eq "試験使用前問題"
        end
      end

      context "論理削除済みのIDを指定した場合" do
        it "404 Not Found になる" do
          patch admin_question_path(archived_question), params: update_params
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "一般ユーザーの場合" do
      before { sign_in_as(user) }
      it "404 Not Found になる" do
        patch admin_question_path(question), params: update_params
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインの場合" do
      it "ランディングページへリダイレクトされる" do
        patch admin_question_path(question), params: update_params
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE /admin/questions/:id" do
    context "管理者としてアクセスした場合" do
      before { sign_in_as(admin) }

      context "未使用の問題を削除する場合（物理削除）" do
        it "レコード自体が削除される" do
          expect {
            delete admin_question_path(question), as: :turbo_stream
          }.to change(Question, :count).by(-1)

          expect(response).to have_http_status(:ok)
          expect(Question.exists?(question.id)).to be_falsey
        end
      end

      context "使用中の問題を削除する場合（論理削除）" do
        it "レコード数は減らず、deleted_at が更新される" do
          expect {
            delete admin_question_path(in_use_question), as: :turbo_stream
          }.not_to change(Question, :count)

          expect(response).to have_http_status(:ok)
          
          expect(in_use_question.reload.deleted_at).to be_present
          
          expect(response.body).to include(%(action="remove"))
        end
      end

      context "論理削除済みのIDを指定した場合" do
        it "404 Not Found になる" do
          delete admin_question_path(archived_question), as: :turbo_stream
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "一般ユーザーの場合" do
      before { sign_in_as(user) }
      it "404 Not Found になる" do
        expect {
          delete admin_question_path(question)
        }.not_to change(Question, :count)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインの場合" do
      it "削除されず、ランディングページへリダイレクトされる" do
        expect {
          delete admin_question_path(question)
        }.not_to change(Question, :count)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
