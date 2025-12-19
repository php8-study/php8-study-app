# frozen_string_literal: true

module Exams
  module HistoryItem
    class Component < ViewComponent::Base
      with_collection_parameter :exam
      delegate :created_at, :score_percentage, :correct_count, :total_questions, :passed?, to: :@exam

      def initialize(exam:)
        @exam = exam
      end

      def render?
        @exam.present?
      end

      def created_month
        created_at.strftime("%b") # 英表記にしたいのでstrftimeを採用
      end

      def link_classes
        "group block bg-white rounded-xl p-5 border shadow-sm hover:shadow-md transition-all duration-200 border-l-[6px] #{accent_border_class} #{wrapper_class} hover:-translate-y-0.5"
      end

      def wrapper_class
        base = "border-slate-100"
        if passed?
          "#{base} hover:border-emerald-200 hover:bg-emerald-50/30"
        else
          "#{base} hover:border-red-200 hover:bg-red-50/30"
        end
      end

      def accent_border_class
        passed? ? "border-l-emerald-500" : "border-l-red-500"
      end

      def text_main_class
        passed? ? "text-emerald-700" : "text-red-700"
      end

      def calendar_bg_class
        passed? ? "bg-emerald-100/50 text-emerald-800" : "bg-red-100/50 text-red-800"
      end

      def calendar_label_class
        passed? ? "text-emerald-600/70" : "text-red-600/70"
      end

      def stamp_text
        passed? ? "PASSED" : "FAILED"
      end

      def stamp_style_class
        passed? ? "text-emerald-600 border-emerald-600 bg-emerald-100/50 -rotate-12" : "text-red-600 border-red-600 bg-red-100/50 rotate-6"
      end
    end
  end
end
