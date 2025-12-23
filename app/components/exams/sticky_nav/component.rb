# frozen_string_literal: true

module Exams
  module StickyNav
    class Component < ViewComponent::Base
      def initialize(animation: false)
        @animation = animation
      end

      private
        def nav_classes
          classes = %w[sticky bottom-0 left-0 w-full z-50 mt-12 pointer-events-none transition-transform duration-500]

          if @animation
            classes << "translate-y-full opacity-0"
          end

          classes.join(" ")
        end
    end
  end
end
