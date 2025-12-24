# frozen_string_literal: true

module Exams
  module ScoreCard
    class Component < ViewComponent::Base
      # 円グラフの円周 (2 * PI * 45 ≈ 282.7)
      CIRCUMFERENCE = 283

      def initialize(exam:, animation: false)
        @exam = exam
        @animation = animation
      end

      def render?
        @exam.present?
      end

      private
      
        def wrapper_animation_class
          @animation ? "opacity-0 translate-y-4" : ""
        end

        def fade_animation_class
          @animation ? "opacity-0" : ""
        end

        def chart_style
          "stroke-dasharray: #{CIRCUMFERENCE}; stroke-dashoffset: #{stroke_offset};"
        end

        def stroke_offset
          return CIRCUMFERENCE if @animation

          CIRCUMFERENCE * (1 - score_ratio)
        end

        def score_ratio
          score_percentage / 100.0
        end

        def chart_color_class
          return "text-slate-200" if @animation

          passed? ? "text-emerald-500" : "text-red-500"
        end

        def initial_score_display
          @animation ? "0" : score_percentage
        end

        def result_title
          passed? ? "PASSED!" : "FAILED..."
        end

        def result_title_class
          passed? ? "text-emerald-500" : "text-red-500"
        end

        def result_description
          if passed?
            "おめでとうございます！<br>合格ラインを突破しました。"
          else
            "残念ながら不合格です。<br>復習して再挑戦しましょう。"
          end
        end

        def passed?
          @exam.passed?
        end

        def score_percentage
          @exam.score_percentage
        end

        def correct_count
          @exam.correct_count
        end

        def total_questions
          @exam.total_questions
        end
    end
  end
end
