# frozen_string_literal: true

module Common
  module ErrorMessages
    class Component < ViewComponent::Base
      def initialize(object:, classes: "")
        @object = object
        @classes = classes
      end

      def render?
        @object.present? && @object.errors.any?
      end
    end
  end
end
