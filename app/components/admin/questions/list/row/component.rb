# frozen_string_literal: true

module Admin
  module Questions
    module List
      module Row
        class Component < ViewComponent::Base
          with_collection_parameter :question

          def initialize(question:)
            @question = question
          end

          private
            def truncate_content
              @question.content.truncate(40)
            end

            def category_name
              @question.category.name
            end

            def badge(present)
              if present
                {
                  text: "あり",
                  classes: "bg-emerald-50 text-emerald-700 ring-emerald-600/20"
                }
              else
                {
                  text: "なし",
                  classes: "bg-slate-50 text-slate-400 ring-slate-500/10"
                }
              end
            end

            def display_id
              "##{@question.id}"
            end
        end
      end
    end
  end
end
