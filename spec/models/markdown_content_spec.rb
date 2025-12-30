# frozen_string_literal: true

require "rails_helper"

RSpec.describe MarkdownContent, type: :model do
  describe "#to_html" do
    subject { described_class.new(text).to_html }

    context "異常系" do
      context "nilのとき" do
        let(:text) { nil }
        it "空文字を返し、エラーにならないこと" do
          is_expected.to eq ""
        end
      end
    end

    context "正常系" do
      let(:text) { "# Title" }

      it "html_safeな文字列を返すこと" do
        expect(subject.html_safe?).to be true
      end
    end

    context "重要な構成設定" do
      context "セキュリティ (filter_html)" do
        let(:text) { '<script>alert("xss")</script>' }

        it "生のHTMLタグをエスケープまたは削除すること" do
          expect(subject).not_to include("<script>")
        end
      end

      context "ハイライト機能の連携" do
        let(:text) { "```php\ncode\n```" }

        it "Rougeプラグインが正しく読み込まれていること" do
          expect(subject).to include('class="highlight"')
        end
      end
    end
  end
end
