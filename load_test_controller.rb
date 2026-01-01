class LoadTestController < ApplicationController
  # セキュリティ制限を全解除（検証用）
  skip_before_action :require_login, raise: false # 認証スキップ
  skip_forgery_protection                         # CSRFスキップ

  # キャッシュを絶対にさせない設定
  before_action :set_no_cache

  def read
    # 本番相当のクエリ（N+1回避含む）
    question = Question.includes(:question_choices).order("RANDOM()").first

    if question
      render json: { id: question.id, choices: question.question_choices.size }
    else
      render json: { status: "no data" }
    end
  end

  def write
    ActiveRecord::Base.transaction do
      # 【負荷再現】あえて 0.05秒 (50ms) 待機してロック時間を伸ばす
      sleep(0.05)

      # 実際に書き込みロックを発生させる（更新内容は適当でOK）
      question = Question.first
      question.touch if question
    end

    render plain: "Written!"
  end

  private

  def set_no_cache
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"
  end
end
