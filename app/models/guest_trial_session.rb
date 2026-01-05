# frozen_string_literal: true

# app/models/guest_trial_session.rb
class GuestTrialSession
  LIMIT = 5

  def initialize(session, user)
    @session = session
    @user = user
  end

  def allow?(question_id)
    id = question_id.to_s

    return true if exempt?(id)

    return false if limit_reached?

    mark_as_visited(id)
    true
  end

  private
    def exempt?(id)
      authenticated? || visited?(id)
    end

    def authenticated?
      @user.present?
    end

    def visited?(id)
      viewed_question_ids.include?(id)
    end

    def limit_reached?
      viewed_question_ids.count >= LIMIT
    end

    def mark_as_visited(id)
      ids = viewed_question_ids
      ids << id
      @session[:guest_viewed_question_ids] = ids
    end

    def viewed_question_ids
      @session[:guest_viewed_question_ids] ||= []
    end
end
