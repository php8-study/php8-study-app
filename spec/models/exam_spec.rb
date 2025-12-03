# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exam, type: :model do
  let(:user) { create(:user) }
  let(:exam) { create(:exam, user: user) }

  describe "#attach_questions!" do
    let(:questions) { create_list(:question, 3) }
    let(:question_ids) { questions.map(&:id) }

    it "ExamQuestionを指定されたID順で一括作成すること" do
      expect {
        exam.attach_questions!(question_ids)
      }.to change(ExamQuestion, :count).by(3)

      created_questions = exam.exam_questions.order(:position)
      expect(created_questions.pluck(:question_id)).to eq(question_ids)
    end

    it "タイムスタンプ(created_at, updated_at)が保存されていること" do
      exam.attach_questions!(question_ids)

      eq = exam.exam_questions.first
      # バルクインサートは自動でタイムスタンプを入れないため、手動設定が効いているか確認
      expect(eq.created_at).to be_present
      expect(eq.updated_at).to be_present
    end
  end

  describe "#finish!" do
    context "まだ完了していない場合" do
      it "completed_at を現在時刻に更新すること" do
        freeze_time do
          exam.finish!
          expect(exam.completed_at).to eq(Time.current)
        end
      end
    end

    context "既に完了している場合" do
      let(:old_time) { 1.day.ago }
      let(:exam) { create(:exam, completed_at: old_time) }

      it "completed_at を更新しないこと" do
        exam.finish!
        expect(exam.reload.completed_at).to be_within(1.second).of(old_time)
      end
    end
  end

  describe "completed?" do
    context "まだ完了していない場合" do
      it "false を返すこと" do
        expect(exam.completed?).to be false
      end
    end

    context "既に完了している場合" do
      let(:exam) { create(:exam, completed_at: Time.current) }

      it "true を返すこと" do
        expect(exam.completed?).to be true
      end
    end
  end

  describe "スコアリングロジック (#score_percentage, #passed?)" do
    def answer_question(exam_question, correct:)
      choice = if correct
        exam_question.question.question_choices.find_by(correct: true)
      else
        exam_question.question.question_choices.find_by(correct: false)
      end
      exam_question.save_answers!([choice.id])
    end

    before do
      questions = create_list(:question, 4, :with_choices)
      exam.attach_questions!(questions.map(&:id))

      eqs = exam.exam_questions.order(:position)

      answer_question(eqs[0], correct: true)
      answer_question(eqs[1], correct: true)
      answer_question(eqs[2], correct: true)
      answer_question(eqs[3], correct: false)
    end

    describe "#total_questions" do
      it "総問題数を返すこと" do
        expect(exam.total_questions).to eq(4)
      end
    end

    describe "#correct_count" do
      it "正解数を正しくカウントすること" do
        expect(exam.correct_count).to eq(3)
      end
    end

    describe "#score_percentage" do
      it "正答率を計算すること (3/4 = 75.0%)" do
        expect(exam.score_percentage).to eq(75.0)
      end

      context "問題数が0の場合" do
        before { exam.exam_questions.destroy_all }
        it "0.0 を返し、ゼロ除算エラーにならないこと" do
          expect(exam.score_percentage).to eq(0.0)
        end
      end
    end

    describe "#passed?" do
      context "正答率が合格基準(70%)以上の場合" do
        it { expect(exam.passed?).to be true }
      end

      context "正答率が合格基準未満の場合" do
        before do
          exam.exam_questions[0..1].each do |eq|
            eq.exam_answers.destroy_all
          end
        end

        it { expect(exam.passed?).to be false }
      end
    end
  end
end
