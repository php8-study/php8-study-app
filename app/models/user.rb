# frozen_string_literal: true

class User < ApplicationRecord
  validates :github_id, presence: true, uniqueness: true
  has_many :exams, dependent: :destroy

  def active_exam
    exams.find_by(completed_at: nil)
  end

  def discard_active_exam
    if target_exam = active_exam
      target_exam.destroy!
    end
  rescue ActiveRecord::ActiveRecordError => e
    Rails.logger.error("Failed to discard active exam for User #{id}: #{e.message}")
  end
end
