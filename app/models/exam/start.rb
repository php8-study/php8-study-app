# frozen_string_literal: true

class Exam::Start
  def initialize(user:)
    @user = user
  end

  def call
    ActiveRecord::Base.transaction do
      @user.discard_active_exam
      exam = @user.exams.create!

      question_ids = Exam::QuestionSelector.new.call
      exam.attach_questions!(question_ids)

      exam
    end
  end
end
