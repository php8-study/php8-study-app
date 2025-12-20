# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Questions::List::Component, type: :component do
  context "問題が存在する場合" do
    let!(:question) { create(:question, content: "テスト問題文") }

    before do
      render_inline(described_class.new(questions: Question.all))
    end

    it "テーブルヘッダーが表示されること" do
      expect(page).to have_content("ID")
      expect(page).to have_content("問題文")
      expect(page).to have_content("カテゴリー")
    end

    it "問題の行がレンダリングされること" do
      expect(page).to have_content("テスト問題文")
    end
  end

  context "問題が存在しない場合" do
    before do
      render_inline(described_class.new(questions: []))
    end

    it "Empty Stateが表示されること" do
      expect(page).to have_content("問題が登録されていません")
      expect(page).to have_content("新しい問題を作成してデータベースに追加しましょう")
    end

    it "新規作成ボタンが表示されること" do
      expect(page).to have_link("問題を新規作成", href: new_admin_question_path)
    end
  end
end
