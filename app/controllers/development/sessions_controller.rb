# frozen_string_literal: true

module Development
  class SessionsController < ApplicationController
    before_action :ensure_development_environment
    skip_before_action :require_login, raise: false

    private
      def ensure_development_environment
        raise ActionController::RoutingError, "Not Found" unless Rails.env.development?
      end

      def sign_in_as
        user = User.find(params[:user_id])
        unless user
          redirect_to root_path, alert: "指定されたユーザーが見つかりません"
          return
        end

        session[:user_id] = user.id

        redirect_to root_path, notice: "開発用: #{user.admin? ? '管理者' : '一般ユーザー'} (ID: #{user.id}) としてログインしました"
      end
  end
end
