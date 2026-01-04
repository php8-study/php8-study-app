# frozen_string_literal: true

module Landing
  module HeroContent
    class Component < ViewComponent::Base
      def initialize(questions_count:)
        @questions_count = questions_count
      end

      private
        def trial_limit
          GuestTrialSession::LIMIT
        end
    end
  end
end
