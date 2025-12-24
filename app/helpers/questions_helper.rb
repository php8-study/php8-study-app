# frozen_string_literal: true

module QuestionsHelper
  def set_question_seo_tags(question)
    content = format_for_seo(question.content)

    set_meta_tags(
      title: "[#{question.category.name}] #{content.truncate(30)}",
      description: "#{content.truncate(110)} ... PHP8技術者認定試験対策の演習問題No.#{question.id}に挑戦しましょう。"
    )
  end

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

  private
    def format_for_seo(text)
      return "" if text.blank?
      strip_tags(text).gsub(/[#*`>\[\]]/, "").squish
    end
end
