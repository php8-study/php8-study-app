# frozen_string_literal: true
require 'rouge/plugins/redcarpet'

module Common
  module TerminalDisplay
    class Component < ViewComponent::Base
      def initialize(body:, label: "Question.php")
        @body = body
        @label = label
      end

      private

      def formatted_body
        renderer = HTMLWithRouge.new(
          filter_html: true,
          hard_wrap: true,
          link_attributes: { rel: 'nofollow', target: "_blank" }
        )

        markdown = Redcarpet::Markdown.new(renderer,
          fenced_code_blocks: true,
          autolink: true,
          tables: true,
          strikethrough: true
        )

        markdown.render(@body).html_safe
      end

      class HTMLWithRouge < Redcarpet::Render::HTML
        include Rouge::Plugins::Redcarpet
      end
    end
  end
end
