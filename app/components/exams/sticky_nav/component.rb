# frozen_string_literal: true

module Exams
  module StickyNav
    class Component < ViewComponent::Base
      def initialize(animation: false)
        @animation = animation
      end

      private

      def nav_classes
        classes = %w[fixed bottom-0 left-0 w-full z-50 transition-transform duration-500]

        if @animation
          classes << "translate-y-full opacity-0 translate-y-4"
        end

        classes.join(" ")
      end
    end
  end
end
