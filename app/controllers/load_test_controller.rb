# frozen_string_literal: true

class LoadTestController < ApplicationController
  # セキュリティ無効化
  skip_before_action :require_login, raise: false
  skip_forgery_protection

  # 全アクション共通でキャッシュを無効化する
  before_action :set_no_cache

  def read
    # 【対策B】本番相当の「ちょっと重い」クエリ
    # ランダム取得 & 選択肢も一緒に引く (N+1回避の負荷も再現)
    # ※ データが空だとエラーになるので、データがない場合は考慮不要
    question = Question.includes(:question_choices).order("RANDOM()").first

    if question
      render json: {
        id: question.id,
        choices: question.question_choices.size
      }
    else
      render json: { status: "no data" }
    end
  end

  def write
    ActiveRecord::Base.transaction do
      # 【対策A】書き込みロック時間のシミュレーション ("Hard Mode")
      # 実際の回答保存処理にかかる時間を想定し、あえて 0.05秒 (50ms) 待機する
      # これにより、本番ロジックをコピーせずとも「複雑な処理」と同等のロック負荷を与えられる
      sleep(0.05)

      # 実際に書き込みロックを発生させる
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
