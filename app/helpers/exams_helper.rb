# frozen_string_literal: true

module ExamsHelper
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
