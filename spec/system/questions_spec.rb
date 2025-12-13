# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ランダム出題", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in_as(user)
  end

  describe "問題画面の表示" do
    context "有効な問題データが存在する場合" do
      let!(:question) { create(:question, :with_choices) }

      it "ランダム出題ボタンから問題ページへ遷移できること" do
        click_link "ランダム問題を解く"

        expect(page).to have_current_path(%r{/questions/\d+})
      end
    end
    context "有効な問題データが存在しない場合" do
      it "アラートが表示され、ダッシュボードにリダイレクトされること" do
        click_link "ランダム問題を解く"

        expect(page).to have_current_path(root_path)
        expect(page).to have_content "現在利用可能な問題がありません"
      end
    end
  end


  describe "解答後の表示" do
    let!(:question) { create(:question, :with_choices) }
    before do
      visit question_path(question)
    end
    shared_examples "解答後の共通表示" do
      it "解説ページ、問題文、ナビゲーションが表示されていること", :aggregate_failures do
        expect(page).to have_content question.official_page
        expect(page).to have_content question.content
        expect(page).to have_link "トップへ戻る", href: root_path
        expect(page).to have_link "次の問題へ", href: random_questions_path
      end
    end

    context "正解の場合" do
      before do
        answer_question(question, correct: true)
        click_button "解答する"
        expect(page).to have_current_path(%r{/questions/\d+/solution}, ignore_query: true)
      end

      it "「正解！」のメッセージが表示されること" do
        expect(page).to have_content "正解！"
      end

      it "選んだ選択肢に正解用のクラスが適用されていること" do
        selected_choice = find(".relative.border-2", text: "YOUR CHOICE")
        expect(selected_choice[:class]).to include("bg-emerald-50")
        expect(selected_choice[:class]).to include("border-emerald-500")
      end

      it_behaves_like "解答後の共通表示"
    end
    context "不正解の場合" do
      before do
        answer_question(question, correct: false)
        click_button "解答する"
        expect(page).to have_current_path(%r{/questions/\d+/solution}, ignore_query: true)
      end

      it "「不正解...」のメッセージが表示されること" do
        expect(page).to have_content "不正解..."
      end

      it "選んだ選択肢に不正解用のクラスが適用されていること" do
        selected_box = find(".relative.border-2", text: "YOUR CHOICE")

        expect(selected_box[:class]).to include("bg-red-50")
        expect(selected_box[:class]).to include("border-red-400")
        expect(selected_box[:class]).to include("border-dashed")
      end

      it "選ばなかった正解の選択肢に正解用のクラスが適用されていること" do
        correct_box = find(".relative.border-2", text: "CORRECT ANSWER")

        expect(correct_box[:class]).to include("bg-emerald-50")
        expect(correct_box[:class]).to include("border-emerald-500")
      end

      it_behaves_like "解答後の共通表示"
    end
  end

  describe "非ログインユーザーの表示" do
    let!(:question) { create(:question, :with_choices) }
    before do
      sign_out
    end

    context "問題ページの場合" do
      before do
        visit question_path(question)
      end
      it "問題は表示されるが、解答ボタンではなくログイン誘導が表示されること" do
        expect(page).to have_content(question.content)

        expect(page).to have_no_button("解答する")
        expect(page).to have_link("ログインして学習をはじめる")
      end
    end
    context "回答後ページの場合" do
      before do
        visit solution_question_path(question)
      end
      it "公式テキストへの参照は表示されるが、通常のナビゲーションではなく、ログイン誘導が表示されること" do
        expect(page).to have_content(question.official_page)

        expect(page).to have_no_link("次の問題へ")
        expect(page).to have_link("ログインして学習をはじめる")
      end
    end
  end

  def answer_question(question, correct:)
    target_choice = question.question_choices.find_by(correct: correct)
    check target_choice.content
    expect(page).to have_checked_field(target_choice.content)
  end
end
