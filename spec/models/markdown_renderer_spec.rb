# frozen_string_literal: true

require "rails_helper"
require "rouge/plugins/redcarpet"

RSpec.describe MarkdownRenderer, type: :model do
  describe ".render" do
    subject { described_class.render(text) }

    context "入力値が空の場合" do
      context "nilのとき" do
        let(:text) { nil }
        it { is_expected.to eq "" }
      end

      context "空文字のとき" do
        let(:text) { "" }
        it { is_expected.to eq "" }
      end
    end

    context "Markdown変換" do
      let(:text) { "# Title\nThis is **bold** text." }

      it "HTML構造に変換されること" do
        expect(subject).to include("<h1>Title</h1>")
        expect(subject).to include("<strong>bold</strong>")
      end

      it "Railsのビューでそのまま表示可能な html_safe な文字列を返すこと" do
        expect(subject.html_safe?).to be true
      end
    end

    context "シンタックスハイライト" do
      let(:text) do
        <<~MARKDOWN
          ```php
          def hello; end
          ```
        MARKDOWN
      end

      it "Rougeが有効になっており、ハイライト用の装飾が行われていること" do
        # Rougeが機能した形跡（highlightクラスの付与とタグの挿入）のみを確認する
        expect(subject).to include('class="highlight"')
        expect(subject).to include("<span")
      end

      it "Redcarpetのオプションにより、指定した言語がクラス名として付与されること" do
        # こちらも機能した形跡の確認のみ
        expect(subject).to match(/class="[^"]*php[^"]*"/)
      end
    end

    context "セキュリティ設定" do
      it "filter_htmlにより、入力された生のHTMLタグが制限されること" do
        text = '<script>alert("xss")</script>'
        expect(described_class.render(text)).not_to include("<script>")
      end
    end
  end
end
