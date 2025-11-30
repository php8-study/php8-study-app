module Admin::QuestionsHelper
  def admin_form_text_area_class
    "w-full border border-gray-300 rounded-lg p-2 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 transition-colors"
  end
  
  def admin_form_label_class
    "block text-sm font-medium text-slate-700"
  end
end
