odule CardHelper
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
end
