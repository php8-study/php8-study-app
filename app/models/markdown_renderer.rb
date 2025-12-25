# frozen_string_literal: true

module MarkdownRenderer
  OPTIONS = {
    filter_html: true,
    hard_wrap: true,
    link_attributes: { rel: "nofollow", target: "_blank" }
  }.freeze

  EXTENSIONS = {
    fenced_code_blocks: true,
    autolink: true,
    tables: true,
    strikethrough: true
  }.freeze

  def self.render(text)
    return "" if text.blank?

    renderer = HTMLWithRouge.new(OPTIONS)
    markdown = Redcarpet::Markdown.new(renderer, EXTENSIONS)
    markdown.render(text).html_safe
  end

  class HTMLWithRouge < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet

    def codespan(code)
      "<code class=\"font-mono text-sm text-red-400 bg-slate-800 rounded px-1.5 py-0.5\">#{code}</code>"
    end
  end
end
