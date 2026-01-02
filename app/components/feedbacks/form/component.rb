# frozen_string_literal: true

module Feedbacks
  module Form
    class Component < ViewComponent::Base
      def initialize(title: "フィードバック", question_id: nil)
        @title = title
        @question_id = question_id
      end
    end
  end
end
