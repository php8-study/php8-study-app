# frozen_string_literal: true

module Common
  module AnswerForm
    class Component < ViewComponent::Base
      def initialize(question:, url:, method: :get, button_text: "解答する", input_name: "user_answer_ids[]", selected_choice_ids: [], guard_answer: false)
        @question = question
        @url = url
        @method = method
        @button_text = button_text
        @input_name = input_name
        @selected_choice_ids = selected_choice_ids
        @guard_answer = guard_answer
      end
    end
  end
end
