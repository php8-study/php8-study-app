# frozen_string_literal: true

class MarkdownRenderer
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

  # スタイルのデフォルト値は持ちません。
  # 呼び出し側が必ず指定する設計です（Viewに関するロジックをModelに持ち込まないため）。
  def self.render(text, inline_code_style: nil)
    return "" if text.blank?

    renderer = HTMLWithRouge.new(OPTIONS.merge(inline_code_style: inline_code_style))
    markdown = Redcarpet::Markdown.new(renderer, EXTENSIONS)
    markdown.render(text).html_safe
  end

  class HTMLWithRouge < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet

    def initialize(extensions = {})
      @inline_code_style = extensions.delete(:inline_code_style)
      super(extensions)
    end

    def codespan(code)
      if @inline_code_style
        "<code class=\"#{@inline_code_style}\">#{code}</code>"
      else
        "<code>#{code}</code>"
      end
    end
  end
end
