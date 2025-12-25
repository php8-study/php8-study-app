# frozen_string_literal: true

module Common
  module ReferenceInfo
    class Component < ViewComponent::Base
      def initialize(question:)
        @question = question
      end

      private
        def official_page
          @question.official_page
        end

        def present?
          official_page.present?
        end
    end
  end
end
