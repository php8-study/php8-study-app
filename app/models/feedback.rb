# frozen_string_literal: true

require "net/http"

class Feedback
  def initialize(message:, question_id: nil, user: nil, webhook_url: Rails.application.credentials.dig(:discord, :webhook_url))
    @message = message
    @question_id = question_id
    @user = user
    @webhook_url = webhook_url
  end

  def save
    return false if @message.blank?

    deliver_notification
    true
  end

  private
    def deliver_notification
      return if @webhook_url.blank?

      post_to_discord(payload)
    end

    def payload
      { content: notification_content }.to_json
    end

    def notification_content
      <<~TEXT
      【フィードバック】
      内容: #{@message}
      #{context_info}
      ユーザーID: #{@user&.id || 'ゲスト'}
      TEXT
    end

    def context_info
      @question_id.present? ? "対象問題ID: #{@question_id}" : "全体フィードバック"
    end

    def post_to_discord(body)
      uri = URI(@webhook_url)
      Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 5, read_timeout: 10) do |http|
        http.post(uri.path, body, { "Content-Type" => "application/json" }).value!
      end
    end
end
