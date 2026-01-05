# frozen_string_literal: true

module ApplicationHelper
  def default_meta_tags
    {
      site: "PHP8Study",
      title: "",
      reverse: true,
      separator: "|",
      description: "【完全無料】PHP8技術者認定初級試験の合格を目指すための学習サイトです。数百問に及ぶ演習問題、本番形式の模擬試験、ランダム出題機能で効率よく学習可能。公式教材への参照付きで、基礎固めから試験直前の総仕上げまで強力にサポートします。",
      keywords: "PHP, PHP8, 技術者認定初級試験, 初級, 問題集, 模擬試験, 過去問, 無料, 資格, 独学, 勉強法, 対策, アプリ",
      canonical: "#{request.base_url}#{request.path}",
      noindex: ! Rails.env.production?,
      icon: [
        { href: image_url("favicon.ico") },
        { href: image_url("apple-touch-icon.png"), rel: "apple-touch-icon", sizes: "180x180", type: "image/png" },
      ],
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: "#{request.base_url}#{request.path}",
        image: image_url("ogp.png"),
        locale: "ja_JP",
      },
      twitter: {
        card: "summary_large_image",
      }
    }
  end

  def render_registration_wall_meta(css_selector: ".restricted-area")
    json_data = {
      "@context": "https://schema.org",
      "@type": "WebPage",
      "isAccessibleForFree": false,
      "hasPart": {
        "@type": "WebPageElement",
        "isAccessibleForFree": false,
        "cssSelector": css_selector
      }
    }

    content_for :head do
      content_tag(:script, type: "application/ld+json") do
        json_data.to_json.html_safe
      end
    end
  end
end
