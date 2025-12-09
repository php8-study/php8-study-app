# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Questions", type: :system do
  let(:admin) { create(:user, :admin) }
  let!(:category) { create(:category, name: "テストカテゴリー") }
  let!(:question) {
    create(:question,
      content: "古い問題文",
      category: category,
      explanation: "解説文が入っています",
      official_page: 10
    )
  }
  let!(:choice) { create(:question_choice, question: question, content: "古い選択肢") }

  before do
    sign_in_as(admin)
    visit admin_questions_path
    expect(page).to have_content "問題管理"
  end

  describe "一覧表示" do
    it "問題一覧が表示され、アクションボタンが存在すること" do
      expect(page).to have_link "新規作成", href: new_admin_question_path
      expect(page).to have_link "管理トップ", href: admin_root_path

      within "#question_#{question.id}" do
        expect(page).to have_content "##{question.id}"
        expect(page).to have_content "古い問題文"
        expect(page).to have_content "テストカテゴリー"
        expect(page).to have_content "あり", count: 2
        expect(page).to have_selector "a[title='編集']"
        expect(page).to have_selector "a[title='削除']"
      end
    end
  end

  describe "新規作成" do
    before do
      click_link "新規作成"
      expect(page).to have_content "問題の新規作成"
    end

    context "入力内容が正しい場合" do
      it "問題と選択肢を正しく作成できる" do
        select "テストカテゴリー", from: "カテゴリー"

        fill_in "question[content]", with: "新しい問題です"
        fill_in "question[explanation]", with: "解説文です"
        fill_in "question[official_page]", with: "123"

        fill_in "question[question_choices_attributes][0][content]", with: "正解の選択肢"
        check "question[question_choices_attributes][0][correct]"

        fill_in "question[question_choices_attributes][1][content]", with: "不正解の選択肢1"
        fill_in "question[question_choices_attributes][2][content]", with: "不正解の選択肢2"
        fill_in "question[question_choices_attributes][3][content]", with: "不正解の選択肢3"

        click_button "保存する"

        expect(page).to have_content "問題を作成しました"
        expect(page).to have_content "新しい問題です"
      end
    end
  end

  describe "問題の編集" do
    before do
      visit edit_admin_question_path(question)
      expect(page).to have_content "問題の編集"
    end
    context "試験ですでに使用されている場合" do
      before do
        create(:exam_question, question: question)
      end

      it "更新すると新しいバージョンが作成され、IDが変化する" do
        fill_in "question[content]", with: "新しい問題文"
        fill_in "question[question_choices_attributes][0][content]", match: :first, with: "新しい選択肢"

        click_button "保存する"

        expect(page).to have_content "問題を保存しました"
        expect(page).to have_field "question[content]", with: "新しい問題文"
        expect(page).to have_field "question[question_choices_attributes][0][content]", with: "新しい選択肢"
        expect(current_path).not_to eq edit_admin_question_path(question)
      end
    end

    context "試験で使用されていない場合" do
      it "更新してもIDは変化しない" do
        fill_in "question[content]", with: "単なる修正です"
        click_button "保存する"

        expect(page).to have_content "問題を保存しました"
        expect(page).to have_field "question[content]", with: "単なる修正です"
        expect(current_path).to eq edit_admin_question_path(question)
      end
    end

    context "選択肢の増減を行う場合" do
      it "選択肢を追加・削除して保存できる" do
        within ".nested-form-wrapper", match: :first do
          find("button[data-action='nested-form#remove']").click
        end

        expect(page).to have_no_field "question[question_choices_attributes][0][content]", with: "古い選択肢"

        click_button "選択肢を追加"

        new_choice_inputs = all("input[name*='[content]']")
        last_choice_input = new_choice_inputs.last

        last_choice_input.set("追加した選択肢")

        click_button "保存する"

        expect(page).to have_content "問題を保存しました"

        expect(page).to have_no_field "question[content]", with: "古い選択肢"
        expect(page).to have_field "question[question_choices_attributes][0][content]", with: "追加した選択肢"
      end
    end

    context "キャンセルした場合" do
      it "一覧ページに戻る" do
        click_link "キャンセル"
        expect(page).to have_current_path(admin_questions_path)
      end
    end
  end

  describe "削除" do
    context "削除可能な場合" do
      it "削除に成功し、一覧から消える" do
        accept_confirm do
          find("a[title='削除']").click
        end

        expect(page).to have_no_content "古い問題文"
      end
    end

    context "削除不可の場合 (試験で使用されている)" do
      before do
        create(:exam_question, question: question)
      end

      it "削除に失敗し、エラーメッセージが表示され、一覧に残ること" do
        accept_confirm do
          find("a[title='削除']").click
        end

        expect(page).to have_content "削除できません"
        expect(page).to have_content "古い問題文"
        expect(page).to have_selector("#question_#{question.id}")
      end
    end
  end
end
