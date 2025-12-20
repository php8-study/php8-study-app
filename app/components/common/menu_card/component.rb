# frozen_string_literal: true

module Common
  module MenuCard
    class Component < ViewComponent::Base
      THEMES = {
        blue: {
          icon_bg: "bg-gradient-to-br from-blue-500 to-blue-600",
          border: "group-hover:border-blue-500",
          text_hover: "group-hover:text-blue-600"
        },
        indigo: {
          icon_bg: "bg-gradient-to-br from-indigo-500 to-indigo-600",
          border: "group-hover:border-indigo-500",
          text_hover: "group-hover:text-indigo-600"
        },
        slate: {
          icon_bg: "bg-gradient-to-br from-slate-600 to-slate-700",
          border: "group-hover:border-slate-500",
          text_hover: "group-hover:text-slate-700"
        },
        orange: {
          icon_bg: "bg-gradient-to-br from-orange-500 to-orange-600",
          border: "group-hover:border-orange-500",
          text_hover: "group-hover:text-orange-600"
        }
      }.freeze

      DEFAULT_THEME = :indigo

      def initialize(title:, description:, url:, theme: :default, icon:)
        @title = title
        @description = description
        @url = url
        @theme = theme.to_sym
        @icon = icon
      end

      private
        def theme_styles
          THEMES[@theme] || THEMES[DEFAULT_THEME]
        end

        def icon_path
          "icons/#{@icon}.svg"
        end
    end
  end
end
