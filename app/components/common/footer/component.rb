# frozen_string_literal: true

module Common
  module Footer
    class Component < ViewComponent::Base
      def initialize(hide: false)
        @hide = hide
      end

      def render?
        !@hide
      end
    end
  end
end
