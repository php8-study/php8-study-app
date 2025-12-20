# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Questions::Form::Component, type: :component do
  let!(:category) { create(:category, name: "テストカテゴリ") }

  context "新規作成の場合" do
    let(:question) { Question.new }

    before do
      question.build_default_choices
      render_inline(described_class.new(question: question))
    end

    it "新規作成用のフォームが表示されること" do
      expect(page).to have_selector("form[action='#{admin_questions_path}'][method='post']")
    end

    it "各入力フィールドが空の状態で表示されること" do
      expect(page.find_field("問題文").value).to be_blank
      expect(page.find_field("解説").value).to be_blank
      expect(page.find_field("公式テキスト参照").value).to be_blank

      expect(page).to have_select("カテゴリー", with_options: ["テストカテゴリ"])
    end

    it "デフォルトの選択肢フィールド（4）が表示されること" do
      expect(page).to have_selector(".nested-form-wrapper", count: 4)
      expect(page).to have_selector("input[placeholder='選択肢を入力...']", count: 4)
      expect(page).to have_selector("input[type='checkbox'][name*='[correct]']", count: 4)
    end

    it "操作ボタンが表示されること" do
      expect(page).to have_button("保存する")
      expect(page).to have_link("キャンセル", href: admin_questions_path)
      expect(page).to have_button("選択肢を追加")
    end
  end

  context "編集の場合" do
    let(:question) do
      create(:question,
        content: "編集する問題文",
        explanation: "編集する解説",
        category: category,
        official_page: "123"
      )
    end

    before do
      create(:question_choice, question: question, content: "正解の選択肢", correct: true)
      create(:question_choice, question: question, content: "不正解の選択肢", correct: false)

      render_inline(described_class.new(question: question))
    end

    it "更新用のフォームが表示されること" do
      expect(page).to have_selector("form[action='#{admin_question_path(question)}']")
    end

    it "既存の値が入力されていること" do
      expect(page).to have_field("問題文", with: "編集する問題文")
      expect(page).to have_field("解説", with: "編集する解説")
      expect(page).to have_field("公式テキスト参照", with: "123")
      expect(page).to have_select("カテゴリー", selected: "テストカテゴリ")
    end

    it "既存の選択肢が表示されること" do
      expect(page).to have_selector(".nested-form-wrapper", count: 2)

      expect(page).to have_field(with: "正解の選択肢")
      expect(page).to have_field(with: "不正解の選択肢")
    end
  end
end
