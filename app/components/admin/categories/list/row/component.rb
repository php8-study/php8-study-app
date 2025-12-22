# frozen_string_literal: true

module Admin
  module Categories
    module List
      module Row
        class Component < ViewComponent::Base
          with_collection_parameter :category

          def initialize(category:, grid_cols:)
            @category = category
            @grid_cols = grid_cols
          end

          private
            def weight_percentage
              "#{@category.weight}%"
            end

            def progress_bar_style
              "width: #{@category.weight}%"
            end
        end
      end
    end
  end
end
