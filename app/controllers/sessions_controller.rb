# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:create, :destroy]
  
  def create
    auth = request.env["omniauth.auth"]
    Rails.logger.debug(auth.inspect)

    user = User.find_or_create_by(github_id: auth.uid)

    session[:user_id] = user.id
    session[:github_info] = auth.info.slice(:nickname, :image)

    redirect_to root_path
  rescue => e
    Rails.logger.error("GitHub OAuth Error: #{e.message}")
    redirect_to root_path
  end

  def destroy
    reset_session
    @current_user = nil
    redirect_to root_path
  end
end
