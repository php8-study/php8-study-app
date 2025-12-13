# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ランダム出題", type: :request do
  describe "ランダム出題" do
    let(:user) { create(:user) }

    before { sign_in_as(user) }

    context "有効な問題データが存在する場合" do
      let!(:question) { create(:question, :with_choices) }
      it "ランダム出題にアクセスすると問題ページにリダイレクトされる" do
        get random_questions_path
        expect(response).to redirect_to(question_path(Question.first))
      end
    end

    context "有効な問題データが存在しない場合" do
      it "ランダム出題にアクセスするとアラート付きでダッシュボードにリダイレクトされる" do
        get random_questions_path
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("現在利用可能な問題がありません")
      end
    end
  end

  describe "非ログインユーザーのアクセス制御" do
    let!(:question) { create(:question, :with_choices) }
    before { sign_out }

    context "問題ページ" do
      it "問題文は表示されるが解答ボタンはなく、ログイン誘導が表示される" do
        get question_path(question)
        expect(response.body).to include(question.content)
        expect(response.body).to include("ログインして学習をはじめる")
        expect(response.body).not_to include("解答する")
      end
    end

    context "回答後ページ" do
      it "公式ページ参照は表示されるが次の問題リンクはなく、ログイン誘導が表示される" do
        get solution_question_path(question)
        expect(response.body).to include(question.official_page.to_s)
        expect(response.body).to include("ログインして学習をはじめる")
        expect(response.body).not_to include("次の問題へ")
      end
    end
  end
end
