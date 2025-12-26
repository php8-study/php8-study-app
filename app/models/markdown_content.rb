# frozen_string_literal: true

class MarkdownContent
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

  def initialize(raw_text)
    @raw_text = raw_text
  end

  def to_html
    return "" if @raw_text.blank?

    renderer = HTMLWithRouge.new(OPTIONS)
    markdown = Redcarpet::Markdown.new(renderer, EXTENSIONS)
    
    markdown.render(@raw_text).html_safe
  end

  class HTMLWithRouge < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
  end

  private_constant :HTMLWithRouge
end
