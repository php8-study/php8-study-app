# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each, type: :system) do
    # :selenium_chrome_headless ではなく :selenium を指定
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400] do |options|
      # メモリ不足対策（必須）
      options.add_argument('disable-dev-shm-usage')
      # サンドボックス無効化（必須）
      options.add_argument('no-sandbox')
      # GPU無効化
      options.add_argument('disable-gpu')
      # 新しいヘッドレスモード（安定性が高い）
      options.add_argument('headless=new')
    end
  end
end
