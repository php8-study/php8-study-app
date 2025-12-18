# frozen_string_literal: true

class User < ApplicationRecord
  validates :github_id, presence: true, uniqueness: true
  has_many :exams, dependent: :destroy

  def active_exam
    exams.find_by(completed_at: nil)
  end
end
