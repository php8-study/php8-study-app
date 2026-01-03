# frozen_string_literal: true

module Feedbacks
  module Form
    class Component < ViewComponent::Base
      def initialize(title:, question_id: nil, classes: nil)
        @title = title
        @question_id = question_id
        @classes = classes
      end
    end
  end
end
