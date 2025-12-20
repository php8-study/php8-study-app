# frozen_string_literal: true

module Exams
  module Check
    class ContentComponent < ViewComponent::Base
      def initialize(active_exam:)
        @active_exam = active_exam
      end

      def render?
        @active_exam.present?
      end

      private
        def formatted_date
          @active_exam.created_at.strftime("%Y年%m月%d日 %H:%M")
        end
    end
  end
end
