module Development
  class SessionsController < ApplicationController
    skip_before_action :require_login, raise: false

    def sign_in_as
      user = User.find(params[:user_id])
      session[:user_id] = user.id
      
      redirect_to root_path, notice: "開発用: #{user.admin? ? '管理者' : '一般ユーザー'} (ID: #{user.id}) としてログインしました"
    end
  end
end
