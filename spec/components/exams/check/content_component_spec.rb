# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exams::Check::ContentComponent, type: :component do
  let(:exam) { create(:exam, created_at: Time.zone.parse("2024-01-01 12:00:00")) }

  before do
    render_inline(described_class.new(active_exam: exam))
  end

  it "未完了試験の警告と開始日時が表示されること" do
    expect(page).to have_content("未完了の模擬試験があります")
    expect(page).to have_content("2024年01月01日 12:00")
  end

  it "「続きから再開」ボタンが正しくリンクされていること" do
    expect(page).to have_link("続きから再開", href: "/exams/#{exam.id}/review")
  end

  it "「破棄して新規開始」ボタンがPOSTフォームとして存在し、確認ダイアログが設定されていること" do
    form = page.find("form[action='/exams'][method='post']")
    
    submit_button = form.find("button[type='submit']")
    expect(submit_button).to have_content("破棄して新規開始")
    
    expect(submit_button["data-turbo-confirm"]).to eq "本当に現在の進捗を破棄してよろしいですか？"
  end
end
