# frozen_string_literal: true

module Admin::CategoriesHelper
  def category_grid_cols
    "grid-cols-[50px_350px_1fr_150px_120px]"
  end

  def admin_input_class
    "w-full rounded-lg border border-slate-300 bg-slate-50 focus:bg-white focus:ring-2 focus:ring-blue-500 focus:border-blue-500 h-12 px-3"
  end

  def admin_inline_input_class(align: :left)
    base = "border border-slate-300 rounded p-1 w-full text-sm"
    align == :center ? "#{base} text-center" : base
  end

  def progress_bar_style(weight)
    "width: #{weight}%"
  end
end
