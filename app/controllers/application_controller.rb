# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :require_login

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def require_login
    unless current_user
      redirect_to root_path, alert: "ログインが必要です"
    end
  end
end
