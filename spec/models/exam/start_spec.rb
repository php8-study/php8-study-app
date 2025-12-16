# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exam::Start, type: :model do
  describe "#call" do
    let(:user) { create(:user) }
    let(:service) { described_class.new(user: user) }

    let(:mock_questions) { create_list(:question, 5) }
    let(:mock_question_ids) { mock_questions.pluck(:id) }

    let(:selector_double) { instance_double(Exam::QuestionSelector) }

    before do
      allow(Exam::QuestionSelector).to receive(:new).and_return(selector_double)
      allow(selector_double).to receive(:call).and_return(mock_question_ids)
    end

    it "Examレコードが1つ作成されること" do
      expect { service.call }.to change(Exam, :count).by(1)
    end

    it "作成されたExamに、Selectorから取得した問題が紐付けられていること" do
      exam = service.call

      expect(exam.questions).to match_array(mock_questions)
      expect(exam.user).to eq user
    end

    context "既に進行中の試験がある場合" do
      let!(:old_exam) { create(:exam, user: user, completed_at: nil) }
      let!(:old_exam_question) { create(:exam_question, exam: old_exam) }

      it "古い試験から新しい試験へ切り替わること" do
        expect(user.active_exam).to eq old_exam

        new_exam = service.call

        expect(user.active_exam).to eq new_exam
        expect(user.active_exam).not_to eq old_exam
      end
    end

    context "処理中にエラーが発生した場合" do
      before do
        allow(selector_double).to receive(:call).and_raise(ActiveRecord::ActiveRecordError)
      end

      it "例外が発生し、Examは作成されないこと（ロールバック）" do
        expect {
          service.call
        }.to raise_error(ActiveRecord::ActiveRecordError)

        expect(Exam.count).to eq 0
      end

      it "古い試験の削除もロールバックされること" do
        create(:exam, user: user, completed_at: nil)

        expect {
          service.call
        }.to raise_error(ActiveRecord::ActiveRecordError)

        expect(user.exams.count).to eq 1
      end
    end
  end
end
