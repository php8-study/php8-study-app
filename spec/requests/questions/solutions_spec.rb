# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Questions::Solutions", type: :request do
  let(:user) { create(:user) }
  let(:question) { create(:question, :with_choices) }
  let(:correct_choice) { question.question_choices.find_by(correct: true) }
  let!(:questions) { create_list(:question, 10) }

  describe "GET /questions/:question_id/solution" do
    context "正常系" do
      context "ログインしている場合" do
        before { sign_in_as(user) }

        it "正常に表示される" do
          get question_solution_path(question), params: { user_answer_ids: [correct_choice.id] }
          expect(response).to have_http_status(:ok)
        end

        it "回答を選択せずに（未回答で）アクセスしてもエラーにならず、正常に表示される" do
          get question_solution_path(question)
          expect(response).to have_http_status(:ok)
        end

        it "6問目以降も制限なくアクセスできる" do
          questions.first(6).each do |q|
            get question_solution_path(q)
            expect(response).to have_http_status(:ok)
          end
        end
      end

      context "未ログインの場合" do
        it "異なる5つの解説までは閲覧でき、SEOタグが付与される" do
          questions.first(5).each do |q|
            get question_solution_path(q)
            expect(response).to have_http_status(:ok)
            expect(response.body).to include "restricted-area"
          end
        end

        it "6問目の新しい解説にアクセスすると、会員登録画面へリダイレクトされる" do
          questions.first(5).each { |q| get question_solution_path(q) }

          get question_solution_path(questions[5])

          expect(response).to redirect_to root_path
          expect(flash[:alert]).to include "5問まで"
        end

        it "閲覧済みの解説への再アクセスは許可される" do
          questions.first(5).each { |q| get question_solution_path(q) }

          get question_solution_path(questions[0])

          expect(response).to have_http_status(:ok)
        end
      end
    end

    context "異常系" do
      it "論理削除された問題の詳細にはアクセスできず404 Not Foundになる" do
        deleted_question = create(:question, deleted_at: Time.current)

        get question_solution_path(deleted_question)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
