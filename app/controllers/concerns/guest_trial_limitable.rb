# frozen_string_literal: true

# app/controllers/concerns/guest_trial_limitable.rb
module GuestTrialLimitable
  extend ActiveSupport::Concern

  private
    def check_guest_trial_limit
      target_id = params[:id] || params[:question_id]

      trial_session = GuestTrialSession.new(session, current_user)

      unless trial_session.allow?(target_id)
        redirect_to root_path, alert: "お試し版は5問までです。会員登録して続きを学習しましょう！"
      end
    end
end
