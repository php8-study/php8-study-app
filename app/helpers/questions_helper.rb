# frozen_string_literal: true

module QuestionsHelper
  def choice_style_class(is_user_selected, is_correct_choice)
    if is_user_selected && is_correct_choice
      "bg-white border-2 border-green-500 shadow-sm"
    elsif is_user_selected && !is_correct_choice
      "bg-white border-2 border-red-500 shadow-sm"
    elsif !is_user_selected && is_correct_choice
      "bg-white border-2 border-yellow-400 border-dashed"
    else
      "bg-gray-50 border-gray-200"
    end
  end
end
