# frozen_string_literal: true

module Admin
  module Questions
    module List
      class Component < ViewComponent::Base
        def initialize(questions:)
          @questions = questions
        end
      end
    end
  end
end
