# frozen_string_literal: true

module Admin
  module Categories
    module Form
      class Component < ViewComponent::Base
        def initialize(category:)
          @category = category
        end

        private
          def input_classes
            "w-full rounded-lg border-slate-300 px-4 py-3 focus:border-indigo-500 focus:ring-indigo-500 text-slate-700 shadow-sm transition-shadow placeholder-slate-300"
          end

          def input_with_suffix_classes
            "#{input_classes} pr-8"
          end

          def label_classes
            "block text-sm font-bold text-slate-600 mb-2"
          end
      end
    end
  end
end
