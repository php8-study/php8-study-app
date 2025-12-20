# frozen_string_literal: true

module Admin
  module Categories
    module List
      module Row
        module Form
          class Component < ViewComponent::Base
            def initialize(category:, grid_cols:)
              @category = category
              @grid_cols = grid_cols
            end

            private
              def input_classes(align: :left)
                base = "border border-slate-300 rounded p-1 w-full text-sm focus:border-blue-500 focus:ring-1 focus:ring-blue-500"
                align == :center ? "#{base} text-center" : base
              end
          end
        end
      end
    end
  end
end
