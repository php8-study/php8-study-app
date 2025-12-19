# frozen_string_literal: true

module Questions
  module ResultStatus
    class Component < ViewComponent::Base
      def initialize(is_correct:)
        @is_correct = is_correct
      end

      private
        def theme
          if @is_correct
            {
              bg: "bg-emerald-50",
              border: "border-emerald-200",
              icon_bg: "bg-emerald-100",
              text: "text-emerald-800",
              sub_text: "text-emerald-600",
              label: "正解！",
              message: "素晴らしい！この調子で進めましょう。",
              icon_name: "check"
            }
          else
            {
              bg: "bg-red-50",
              border: "border-red-200",
              icon_bg: "bg-red-100",
              text: "text-red-800",
              sub_text: "text-red-600",
              label: "不正解...",
              message: "解説を読んで復習しましょう。",
              icon_name: "x"
            }
          end
        end
    end
  end
end
