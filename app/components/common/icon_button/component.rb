# frozen_string_literal: true

module Common
  module IconButton
    class Component < ViewComponent::Base
      VARIANTS = {
        primary: "text-indigo-600 hover:bg-indigo-50",
        secondary:   "text-slate-400 hover:text-slate-600 hover:bg-slate-100",
        danger:    "text-red-600 hover:bg-red-50"
      }.freeze

      def initialize(href:, icon:, variant: :primary, title: nil, method: :get, confirm: nil, data: {})
        @href = href
        @icon = icon
        @variant = VARIANTS[variant] || VARIANTS[:primary]
        @title = title
        @method = method
        @confirm = confirm
        @data = data
      end

      def call
        helpers.link_to(@href, class: merged_classes, title: @title, aria: { label: @title }, data: data_attributes) do
          helpers.inline_svg_tag(icon_path, class: "w-5 h-5", aria_hidden: true)
        end
      end

      private

        def icon_path
          "icons/#{@icon}.svg"
        end

        def data_attributes
          attributes = @data.dup
          attributes[:turbo_method] = @method if @method != :get
          attributes[:turbo_confirm] = @confirm if @confirm.present?
          attributes
        end

        def merged_classes
          class_names(
            "p-2 rounded-lg transition-colors inline-flex items-center justify-center",
            @variant
          )
        end
    end
  end
end
