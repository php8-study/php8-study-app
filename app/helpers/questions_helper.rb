# frozen_string_literal: true

module QuestionsHelper
  # 問題ページ用metatag出力
  def set_question_seo_tags(question)
    content = format_for_seo(question.content)

    set_meta_tags(
      title: "[#{question.category.name}] #{content.truncate(30)}",
      description: "#{content.truncate(110)} ... PHP8技術者認定試験対策の演習問題No.#{question.id}に挑戦しましょう。"
    )
  end

  # 解説ページ用metatag出力
  def set_question_explanation_seo_tags(question)
    content = format_for_seo(question.content)
    explanation = format_for_seo(question.explanation)

    desc = if explanation.present?
      explanation.truncate(140)
    else
      "#{content.truncate(80)}... 正解と公式書籍への案内を確認しましょう。"
    end

    set_meta_tags(
      title: "[解説] #{question.category.name}: #{content.truncate(30)}",
      description: desc
    )
  end

  # JSON-LD出力（Quiz構造化データ）
  def question_json_ld(question)
    content = format_for_seo(question.content)
    explanation = format_for_seo(question.explanation)

    json_ld = {
      "@context": "https://schema.org",
      "@type": "Quiz",
      "name": "PHP8演習問題 No.#{question.id} 解説",
      "mainEntity": {
        "@type": "Question",
        "name": "#{question.category.name}の問題",
        "text": content,
        "acceptedAnswer": {
          "@type": "Answer",
          "text": explanation.presence || "正解と解説はサイト内で確認してください。"
        }
      }
    }
    tag.script(json_ld.to_json.html_safe, type: "application/ld+json")
  end

  private
    def format_for_seo(text)
      return "" if text.blank?
      strip_tags(text).gsub(/[#*`>\[\]]/, "").squish
    end
end
