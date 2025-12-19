# frozen_string_literal: true

module Questions
  module StickyNav
    class Component < ViewComponent::Base
      def initialize(next_path: nil)
        @next_path = next_path
      end
    end
  end
end
