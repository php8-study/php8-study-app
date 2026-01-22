# frozen_string_literal: true

module Common
  module Button
    class Component < ViewComponent::Base
      VARIANTS = {
        primary: "bg-indigo-600 text-white hover:bg-indigo-700 shadow-md border-transparent focus:ring-indigo-500",
        secondary: "bg-white text-slate-600 border-slate-200 hover:bg-slate-50 hover:border-slate-300 shadow-sm border focus:ring-slate-200",
        ghost: "bg-transparent text-slate-600 hover:bg-slate-100 hover:text-slate-900 border-transparent focus:ring-slate-200",
        black: "bg-black text-white hover:bg-zinc-800 shadow-md border-transparent focus:ring-zinc-500"
      }.freeze

      SIZES = {
        sm: "px-3 py-1.5 text-sm",
        md: "px-4 py-2 text-base",
        lg: "px-6 py-3 text-lg",
        xl: "px-8 py-4 text-lg"
      }.freeze

      def initialize(href: nil, variant: :primary, size: :md, type: :button, **system_arguments)
        @href = href
        @variant = VARIANTS.key?(variant) ? variant : :primary
        @size = SIZES.key?(size) ? size : :md
        @type = type
        @system_arguments = system_arguments
      end

      def call
        @system_arguments[:class] = class_names(
          *default_classes,
          VARIANTS[@variant],
          SIZES[@size],
          @system_arguments[:class]
        )

        if @href.present?
          helpers.link_to(@href, @system_arguments) { content }
        else
          @system_arguments[:type] = @type
          helpers.button_tag(@system_arguments) { content }
        end
      end

      private
        def default_classes
          %w[
          inline-flex items-center justify-center font-bold rounded-xl transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed
          ]
        end
    end
  end
end
