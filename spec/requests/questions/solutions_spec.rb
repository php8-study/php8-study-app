# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Questions::Solutions", type: :request do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe "GET /questions/:question_id/solution" do
    let(:correct_choice) { question.question_choices.find_by(correct: true) }

    context "正常系" do
      it "ログイン状態でアクセスすると、正常に表示される" do
        sign_in_as(user)

        get question_solution_path(question), params: { user_answer_ids: [correct_choice.id] }
        expect(response).to have_http_status(:ok)
      end

      it "回答を選択せずに（未回答で）アクセスしてもエラーにならず、正常に表示される" do
        sign_in_as(user)

        get question_solution_path(question)
        expect(response).to have_http_status(:ok)
      end

      it "未ログインでもアクセス可能で、正常に表示される" do
        get question_solution_path(question)
        expect(response).to have_http_status(:ok)
      end
    end

    context "異常系" do
      it "存在しないIDにアクセスすると404 Not Foundになる" do
        get "/questions/0/solution"
        expect(response).to have_http_status(:not_found)
      end

      it "論理削除された問題の詳細にはアクセスできず404 Not Foundになる" do
        deleted_question = create(:question, deleted_at: Time.current)

        get question_solution_path(deleted_question)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
