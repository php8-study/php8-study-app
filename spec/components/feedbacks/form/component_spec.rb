require "rails_helper"

RSpec.describe Feedbacks::Form::Component, type: :component do
  let(:title) { "問題を報告する" }
  let(:question_id) { 123 }

  it "リンクテキストが正しく表示されること" do
    render_inline(described_class.new(title: title))
    expect(page).to have_link(title)
  end

  it "question_idが渡された時、リンクのURLパラメータに正しく含まれること" do
    render_inline(described_class.new(title: title, question_id: question_id))
    expect(page).to have_link(title, href: /question_id=#{question_id}/)
  end

  it "Turbo Stream形式のリクエストを送る設定になっていること" do
    render_inline(described_class.new(title: title))
    expect(page).to have_css("a[data-turbo-stream='true']")
  end
end
