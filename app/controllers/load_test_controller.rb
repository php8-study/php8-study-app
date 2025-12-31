# frozen_string_literal: true

class LoadTestController < ApplicationController
  # テスト用なので認証・CSRF・キャッシュをすべて無効化
  skip_before_action :require_login, raise: false
  skip_forgery_protection

  # 読み込み (Read) 用
  def read
    # キャッシュを使わずDBからデータを引く
    count = Question.count
    # 念のため少しデータも取ってみる
    questions = Question.limit(10).pluck(:id, :content)
    render json: { count: count, data_size: questions.size }
  end

  # 書き込み (Write) 用
  def write
    ActiveRecord::Base.transaction do
      # 1番目の問題の updated_at を更新する（ロック発生のシミュレーション）
      question = Question.first
      question.touch if question
    end
    render plain: "Written!"
  end
end
