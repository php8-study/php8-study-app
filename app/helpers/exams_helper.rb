# frozen_string_literal: true

module ExamsHelper
  def exam_status_theme(exam)
    if exam.passed?
      {
        wrapper_class: "border-slate-100 hover:border-emerald-200 hover:bg-emerald-50/30",
        accent_border: "border-l-emerald-500",
        text_main: "text-emerald-700",
        calendar_bg: "bg-emerald-100/50 text-emerald-800",
        calendar_label: "text-emerald-600/70",
        stamp_text: "PASSED",
        stamp_style: "text-emerald-600 border-emerald-600 bg-emerald-100/50 -rotate-12",
      }
    else
      {
        wrapper_class: "border-slate-100 hover:border-red-200 hover:bg-red-50/30",
        accent_border: "border-l-red-500",
        text_main: "text-red-700",
        calendar_bg: "bg-red-100/50 text-red-800",
        calendar_label: "text-red-600/70",
        stamp_text: "FAILED",
        stamp_style: "text-red-600 border-red-600 bg-red-100/50 rotate-6",
      }
    end
  end

  def reveal_animation_classes(needs_animation)
    {
      wrapper: needs_animation ? "opacity-0 translate-y-4" : "",
      fade:    needs_animation ? "opacity-0" : ""
    }
  end

  def exam_chart_attributes(exam, needs_animation)
    percentage = exam.score_percentage
    passed = exam.passed?
    circumference = 283 # 2 * PI * 45 ≈ 282.7
    offset = circumference - (percentage / 100.0 * circumference)

    if needs_animation
      {
        initial_color: "text-slate-200",
        style: "stroke-dasharray: 0, #{circumference};",
        initial_score: "0"
      }
    else
      color_class = passed ? "text-emerald-500" : "text-red-500"
      {
        initial_color: color_class,
        style: "stroke-dasharray: #{circumference}, #{circumference}; stroke-dashoffset: #{offset};",
        initial_score: percentage
      }
    end
  end

  def exam_result_message(passed)
    if passed
      {
        title: "PASSED!",
        title_class: "text-emerald-500",
        description: "おめでとうございます！<br>合格ラインを突破しました。"
      }
    else
      {
        title: "FAILED...",
        title_class: "text-red-500",
        description: "残念ながら不合格です。<br>復習して再挑戦しましょう。"
      }
    end
  end

  def exam_progress_percentage(exam)
    return 0 if exam.total_questions.zero?
    (exam.answered_count.to_f / exam.total_questions * 100).round
  end

  def review_card_classes(is_answered)
    base_classes = "flex flex-col items-center justify-center h-20 rounded-2xl transition-all duration-200 relative group"
    
    status_classes = if is_answered
      "bg-indigo-50 border border-indigo-100 text-indigo-700 hover:bg-indigo-100 hover:border-indigo-200 hover:-translate-y-1 shadow-sm"
    else
      "bg-white border-2 border-slate-300 border-dashed text-slate-400 hover:border-slate-400 hover:text-slate-600 hover:bg-slate-50"
    end
    "#{base_classes} #{status_classes}"
  end
end
