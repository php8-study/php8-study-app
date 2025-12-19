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
