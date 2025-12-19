# frozen_string_literal: true

module Common
  module Header
    class Component < ViewComponent::Base
      def initialize(current_user:, github_info:, hide: false)
        @current_user = current_user
        @github_info = github_info || {}
        @hide = hide
      end

      def render?
        !@hide
      end

      def logged_in?
        @current_user.present?
      end

      def nickname
        @github_info["nickname"]
      end

      def avatar_url
        @github_info["image"]
      end
    end
  end
end
