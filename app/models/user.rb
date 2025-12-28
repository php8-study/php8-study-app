# frozen_string_literal: true

class User < ApplicationRecord
  validates :github_id, presence: true, uniqueness: true
  has_many :exams, dependent: :destroy
  has_many :exam_questions, through: :exams


  def active_exam
    exams.in_progress.first
  end
end
