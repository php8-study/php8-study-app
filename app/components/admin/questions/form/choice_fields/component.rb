# frozen_string_literal: true

module Admin
  module Questions
    module Form
      module ChoiceFields
        class Component < ViewComponent::Base
          def initialize(f:)
            @f = f
          end
        end
      end
    end
  end
end
