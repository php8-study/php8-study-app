# frozen_string_literal: true

module Common
  module ErrorPage
    class Component < ViewComponent::Base
      def initialize(code:, title:, badge_text:, badge_classes: "rotate-0")
        @code = code
        @title = title
        @badge_text = badge_text
        @badge_classes = badge_classes
      end
    end
  end
end
