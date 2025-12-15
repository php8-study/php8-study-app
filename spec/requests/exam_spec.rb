# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Exams", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  let!(:completed_exam) { create(:exam, :completed, :with_questions, user: user) }
  let!(:active_exam) { create(:exam, :with_questions, user: user) }

  before { sign_in_as(user) }

  describe "GET /index" do
    context "正常系" do
      it "完了済みの試験のみが表示され、進行中の試験は表示されない" do
        get exams_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("exams/#{completed_exam.id}")
        expect(response.body).not_to include("exams/#{active_exam.id}")
      end

      it "他人の試験は表示されない" do
        other_exam = create(:exam, :completed, user: other_user)
        get exams_path
        expect(response.body).not_to include("exams/#{other_exam.id}")
      end

      context "表示する試験が1件もない場合" do
        before do
          user.exams.destroy_all
        end

        it "エラーにならず、正常にページが表示される" do
          get exams_path
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context "未ログインの場合" do
      before { sign_out }

      it "ログイン画面へリダイレクトされる" do
        get exams_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /exams/check" do
    context "正常系" do
      context "進行中の試験がある場合" do
        it "再開確認画面（checkテンプレート）が表示される" do
          get check_exams_path
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("未完了の模擬試験があります")
        end
      end

      context "試験履歴が全くない（進行中もない）場合" do
        before do
          user.exams.destroy_all
        end

        it "自動開始画面（auto_startテンプレート）が表示される" do
          get check_exams_path
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("試験データを作成しています")
        end
      end
    end

    context "未ログインの場合" do
      before { sign_out }

      it "ログイン画面へリダイレクトされる" do
        get check_exams_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /exams" do
    context "正常系" do
      it "新しい試験が作成され、その第1問へリダイレクトされる" do
        previous_exam_id = active_exam.id

        post exams_path
        new_exam = Exam.where(user: user).order(created_at: :desc).first

        expect(new_exam.id).not_to eq previous_exam_id
        expect(response).to redirect_to(exam_exam_question_path(new_exam, new_exam.exam_questions.first))
      end
    end

    context "異常系（サービス層でのエラー）" do
      before do
        allow_any_instance_of(Exam::Start).to receive(:call).and_raise(StandardError, "Something went wrong")
      end

      it "エラーログを出力し、ルートパスへリダイレクトする" do
        expect(Rails.logger).to receive(:error).with(/Exam Start Failed/)

        expect {
          post exams_path
        }.not_to change(Exam, :count)

        expect(response).to redirect_to(root_path)
      end
    end

    context "未ログインの場合" do
      before { sign_out }

      it "ログイン画面へリダイレクトされる" do
        post exams_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /exams/:id" do
    context "正常系" do
      it "自分の試験にはアクセスできる" do
        get exam_path(completed_exam)
        expect(response).to have_http_status(:ok)
      end

      it "パラメータ reveal=true がある場合もアクセスできる" do
        get exam_path(completed_exam, reveal: true)
        expect(response).to have_http_status(:ok)
      end
    end

    context "異常系" do
      let(:other_exam) { create(:exam, user: other_user) }

      it "他人の試験にはアクセスできず404になる" do
        get exam_path(other_exam)
        expect(response).to have_http_status(:not_found)
      end

      it "進行中の試験にはアクセスできず404になる" do
        get exam_path(active_exam)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインの場合" do
      before { sign_out }

      it "ログイン画面へリダイレクトされる" do
        get exam_path(active_exam)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /exams/:id/submissions" do
    context "正常系" do
      it "試験を終了し、結果画面（reveal付き）へリダイレクトする" do
        post submissions_exam_path(active_exam)

        active_exam.reload
        expect(active_exam.completed_at).to be_present
        expect(response).to redirect_to(exam_path(active_exam, reveal: true))
      end
    end

    context "異常系" do
      context "finish! が false を返した場合" do
        before do
          allow_any_instance_of(Exam).to receive(:finish!).and_return(false)
        end

        it "ルートパスへリダイレクトされる" do
          post submissions_exam_path (active_exam)
          expect(response).to redirect_to(root_path)
        end
      end

      context "既に完了している試験を提出しようとした場合" do
        it "404 Not Found になる" do
          post submissions_exam_path (completed_exam)
          expect(response).to have_http_status(:not_found)
        end
      end

      context "存在しない試験IDで提出しようとした場合" do
        it "404 Not Found になる" do
          post submissions_exam_path(id: 0)
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "未ログインの場合" do
      before { sign_out }

      it "ログイン画面へリダイレクトされる" do
        post submissions_exam_path(active_exam)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /exams/:id/review" do
    context "正常系" do
      it "確認画面が表示される" do
        get review_exam_path(active_exam)
        expect(response).to have_http_status(:ok)
      end
    end

    context "異常系" do
      let(:other_exam) { create(:exam, user: other_user) }

      it "他人の試験の確認画面にはアクセスできず404になる" do
        get review_exam_path(other_exam)
        expect(response).to have_http_status(:not_found)
      end

      it "終了した試験の確認画面にはアクセスできず404になる" do
        get review_exam_path(completed_exam)
        expect(response).to have_http_status(:not_found)
      end

      it "存在しない試験IDにアクセスすると404になる" do
        get review_exam_path(id: 0)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインの場合" do
      before { sign_out }

      it "ログイン画面へリダイレクトされる" do
        get review_exam_path(completed_exam)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
