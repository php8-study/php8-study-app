# frozen_string_literal: true

require "rails_helper"

RSpec.describe QuestionsHelper, type: :helper do
  let(:category) { create(:category, name: "制御構文") }
  let(:question) { create(:question, category: category, content: "```php\necho 'hello';\n```", explanation: "これは解説です。") }

  describe "SEOタグの設定" do
    it "問題ページのタイトルにカテゴリ名と問題内容が含まれること" do
      helper.set_question_seo_tags(question)
      expect(helper.title).to include("[制御構文]")
      expect(helper.title).to include("echo 'hello';")
    end

    it "解説ページのタイトルに[解説]というプレフィックスがつくこと" do
      helper.set_question_explanation_seo_tags(question)
      expect(helper.title).to start_with("[解説]")
    end
  end

  describe "構造化データ出力" do
    it "JSON-LDがscriptタグとして出力され、中身に問題内容が含まれること" do
      result = helper.question_json_ld(question)

      expect(result).to start_with('<script type="application/ld+json">')
      expect(result).to include('"@type":"Quiz"')
      expect(result).to include("echo 'hello';")
      expect(result).to end_with("</script>")
    end

    it "解説が空の場合でも、デフォルトのテキストがセットされてエラーにならないこと" do
      question.explanation = nil
      result = helper.question_json_ld(question)

      expect(result).to include("正解と解説はサイト内で確認してください。")
    end
  end
end
