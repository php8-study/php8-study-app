# frozen_string_literal: true

module Common
  module DevelopmentTools
    class Component < ViewComponent::Base
      def render?
        Rails.env.development?
      end

      private
        def development_users
          User.order(:id)
        end
    end
  end
end
