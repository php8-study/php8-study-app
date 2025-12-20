# frozen_string_literal: true

module Admin
  module Questions
    module Form
      class Component < ViewComponent::Base
        def initialize(question:)
          @question = question
        end

        private
          def categories
            Category.all
          end

          def input_classes
            "w-full rounded-lg border-slate-300 px-4 py-3 focus:border-indigo-500 focus:ring-indigo-500 text-slate-700 shadow-sm transition-shadow placeholder-slate-300"
          end

          def label_classes
            "block text-sm font-bold text-slate-600 mb-2"
          end
      end
    end
  end
end
