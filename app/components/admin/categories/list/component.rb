# frozen_string_literal: true

module Admin
  module Categories
    module List
      class Component < ViewComponent::Base
        GRID_COLS = "grid-cols-[50px_350px_1fr_150px_120px]"

        def initialize(categories:)
          @categories = categories
        end
      end
    end
  end
end
