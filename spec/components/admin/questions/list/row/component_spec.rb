# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Questions::List::Row::Component, type: :component do
  let(:category) { create(:category, name: "テストカテゴリ") }
  let(:question) { create(:question, content: "これは非常に長い問題文です。" * 5, category: category, official_page: 123, explanation: "解説文") }

  context "全ての情報がある場合" do
    before do
      render_inline(described_class.new(question: question))
    end

    it "IDが表示されること" do
      expect(page).to have_content("##{question.id}")
    end

    it "問題文が省略されて表示されること" do
      expected_content = question.content.truncate(40)
      expect(page).to have_content(expected_content)
    end

    it "カテゴリー名が表示されること" do
      expect(page).to have_content("テストカテゴリ")
    end

    it "参照・解説の「あり」バッジが表示されること" do
      expect(page).to have_css("span.bg-emerald-50", text: "あり", count: 2)
    end

    it "編集・削除ボタンが表示されること" do
      expect(page).to have_link(href: edit_admin_question_path(question))
      expect(page).to have_link(href: admin_question_path(question))
    end
  end

  context "情報が欠けている場合" do
    let(:question_empty) { create(:question, category: category, official_page: nil, explanation: nil) }

    before do
      render_inline(described_class.new(question: question_empty))
    end

    it "参照・解説が「なし」バッジで表示されること" do
      expect(page).to have_css("span.bg-slate-50", text: "なし", count: 2)
    end
  end
end
