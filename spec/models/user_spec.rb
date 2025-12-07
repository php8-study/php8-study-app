# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe "#active_exam" do
    context "進行中の試験がある場合" do
      let!(:exam) { create(:exam, user: user, completed_at: nil) }

      it "その試験を返すこと" do
        expect(user.active_exam).to eq(exam)
      end
    end

    context "完了済みの試験しかない場合" do
      before { create(:exam, user: user, completed_at: Time.current) }

      it "nil を返すこと" do
        expect(user.active_exam).to be_nil
      end
    end
  end

  describe "#discard_active_exam" do
    context "進行中の試験がある場合" do
      let!(:exam) { create(:exam, user: user, completed_at: nil) }
      let!(:exam_question) { create(:exam_question, exam: exam) }
      let!(:exam_answer) { create(:exam_answer, exam_question: exam_question) }

      it "試験を削除すること" do
        user.discard_active_exam
        expect(Exam.exists?(exam.id)).to be false
        expect(ExamQuestion.exists?(exam_question.id)).to be false
        expect(ExamAnswer.exists?(exam_answer.id)).to be false
      end
    end

    context "進行中の試験がない場合" do
      it "何もせずエラーにならないこと" do
        expect { user.discard_active_exam }.not_to raise_error
      end
    end

    context "削除中にエラーが発生した場合" do
      let!(:exam) { create(:exam, user: user, completed_at: nil) }

      before do
        allow(exam).to receive(:destroy!).and_raise(ActiveRecord::ActiveRecordError, "DB Error")
        allow(user).to receive(:active_exam).and_return(exam)
      end

      it "例外を発生させず、ログを出力すること" do
        expect(Rails.logger).to receive(:error).with(/Failed to discard active exam/)
        expect { user.discard_active_exam }.not_to raise_error
      end
    end
  end
end
