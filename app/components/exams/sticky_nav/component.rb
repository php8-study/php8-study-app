# frozen_string_literal: true

module Exams
  module StickyNav
    class Component < ViewComponent::Base
      def initialize(animation: false)
        @animation = animation
      end

      private
        def nav_classes
          [*base_nav_classes, *animation_classes].join(" ")
        end

        def base_nav_classes
          %w[sticky bottom-0 left-0 w-full z-1 mt-12 pointer-events-none transition-transform duration-500]
        end

        def animation_classes
          return [] unless @animation
          %w[translate-y-full opacity-0]
        end
    end
  end
end
