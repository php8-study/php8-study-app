# frozen_string_literal: true

module CardHelper
  def card_theme_classes(theme_color)
    theme = theme_color.presence || "default"

    colors = {
      "blue" => {
        icon_bg: "bg-gradient-to-br from-blue-500 to-blue-600",
        border: "group-hover:border-blue-500",
        hover: "group-hover:text-blue-600",
        arrow: "text-blue-500"
      },
      "indigo" => {
        icon_bg: "bg-gradient-to-br from-indigo-500 to-indigo-600",
        border: "group-hover:border-indigo-500",
        hover: "group-hover:text-indigo-600",
        arrow: "text-indigo-500"
      },
      "slate" => {
        icon_bg: "bg-gradient-to-br from-slate-600 to-slate-700",
        border: "group-hover:border-slate-500",
        hover: "group-hover:text-slate-700",
        arrow: "text-slate-500"
      },
      "orange" => {
        icon_bg: "bg-gradient-to-br from-orange-500 to-orange-600",
        border: "group-hover:border-orange-500",
        hover: "group-hover:text-orange-600",
        arrow: "text-orange-500"
      },
      "default" => {
        icon_bg: "bg-gradient-to-br from-indigo-500 to-indigo-600",
        border: "group-hover:border-indigo-500",
        hover: "group-hover:text-indigo-600",
        arrow: "text-indigo-500"
      }
    }

    colors[theme] || colors["default"]
  end

  def card_icon_path(key)
    icons = {
      "beaker"    => "M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z",
      "clipboard" => "M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4",
      "chart"     => "M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z",
      "cog"       => "M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z M15 12a3 3 0 11-6 0 3 3 0 016 0z"
    }
    icons[key] || "M13 10V3L4 14h7v7l9-11h-7z"
  end
end
