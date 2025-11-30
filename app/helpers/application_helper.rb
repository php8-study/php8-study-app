# frozen_string_literal: true

module ApplicationHelper
  def flash_class(type)
    base_classes = "mt-2 px-4 py-2 rounded-2xl shadow-md mb-2"
    case type
    when "notice"
      "#{base_classes} bg-green-200 text-green-900"
    when "alert", "error"
      "#{base_classes} bg-red-200 text-red-900"
    else
      "#{base_classes} bg-blue-200 text-blue-900"
    end
  end

  def container_class
    "max-w-screen-xl mx-auto w-full"
  end
end
