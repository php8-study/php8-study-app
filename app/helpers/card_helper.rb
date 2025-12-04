# frozen_string_literal: true

module CardHelper
  def card_theme_classes(theme_color)
    theme = theme_color.presence || "indigo"

    colors = {
      "blue"    => { bg: "bg-blue-500",    text: "text-blue-600",    border: "group-hover:border-blue-500" },
      "indigo"  => { bg: "bg-indigo-500",  text: "text-indigo-600",  border: "group-hover:border-indigo-500" },
      "slate"   => { bg: "bg-slate-500",   text: "text-slate-600",   border: "group-hover:border-slate-400" },
      "orange"  => { bg: "bg-orange-500",  text: "text-orange-600",  border: "group-hover:border-orange-400" },
      "default" => { bg: "bg-indigo-500",  text: "text-indigo-600",  border: "group-hover:border-indigo-500" }
    }

    colors[theme] || colors["default"]
  end

  def card_icon_path(path)
    path.presence || "M13 10V3L4 14h7v7l9-11h-7z"
  end
end
