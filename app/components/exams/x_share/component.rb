# frozen_string_literal: true

module Exams
  module XShare
    class Component < ViewComponent::Base
      def initialize(exam:)
        @exam = exam
      end

      def render?
        @exam.present?
      end

      private
        def twitter_share_url
          # 改行や並び順を厳密に制御するため、textパラメータに全て含める
          params = {
            text: full_share_text
          }
          "https://twitter.com/intent/tweet?#{params.to_query}"
        end

        def full_share_text
          [
            "PHP8技術者認定初級試験の模擬試験で#{score_percentage}点を取りました！",
            "Result: #{result_status}",
            request.base_url,
            hash_tags
          ].join("\n")
        end

        def hash_tags
          "#PHP8技術者認定初級試験 #PHP8Study #PHP"
        end

        def score_percentage
          @exam.score_percentage
        end

        def result_status
          @exam.passed? ? "🈴 PASSED! 🎉" : "😢 FAILED..."
        end
    end
  end
end
