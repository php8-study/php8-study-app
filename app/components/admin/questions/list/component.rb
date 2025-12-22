# frozen_string_literal: true

module Admin
  module Questions
    module List
      class Component < ViewComponent::Base
        def initialize(questions:)
          @questions = questions
        end

        private
          def header_th(text, align: :left, classes: "px-3")
            base_classes = "py-3.5 text-xs font-bold uppercase tracking-wider text-slate-500"
            alignment_class = "text-#{align}"

            content_tag :th, text, scope: "col", class: "#{base_classes} #{alignment_class} #{classes}"
          end
      end
    end
  end
end
