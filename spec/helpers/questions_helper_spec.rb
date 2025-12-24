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
end
