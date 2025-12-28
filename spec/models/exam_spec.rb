# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exam, type: :model do
  describe "ファクトリ" do
    it "有効なファクトリを持つこと" do
      expect(build(:exam)).to be_valid
    end
  end

  describe "スコープ" do
    let!(:in_progress_exam) { create(:exam, completed_at: nil) }
    let!(:completed_exam) { create(:exam, completed_at: Time.current) }

    describe ".in_progress" do
      it "完了していない試験のみが含まれること" do
        expect(Exam.in_progress).to include(in_progress_exam)
      end

      it "完了済みの試験が含まれないこと" do
        expect(Exam.in_progress).not_to include(completed_exam)
      end
    end

    describe ".completed" do
      it "完了済みの試験のみが含まれること" do
        expect(Exam.completed).to include(completed_exam)
      end

      it "完了していない試験が含まれないこと" do
        expect(Exam.completed).not_to include(in_progress_exam)
      end
    end
  end

  describe "ドメインメソッド" do
    let(:user) { create(:user) }
    let(:exam) { create(:exam, user: user) }

    describe "#attach_questions!" do
      let(:questions) { create_list(:question, 3) }

      it "指定された問題IDでExamQuestionを一括作成し、positionが正しく振られること" do
        exam.attach_questions!(questions.pluck(:id))

        expect(exam.exam_questions.count).to eq 3
        expect(exam.questions).to match_array(questions)

        expect(exam.exam_questions.pluck(:position).sort).to eq [1, 2, 3]
      end
    end

    describe "#finish!" do
      context "まだ完了していない場合" do
        it "completed_at を現在時刻に更新すること" do
          travel_to Time.current do
            expect { exam.finish! }.to change { exam.completed_at }.from(nil)
            expect(exam.completed_at).to be_within(1.second).of(Time.current)
          end
        end
      end

      context "既に完了している場合" do
        let(:exam) { create(:exam, :completed, user: user) }

        it "completed_at を更新しないこと（冪等性）" do
          original_time = exam.completed_at

          travel 1.hour do
            expect { exam.finish! }.not_to change { exam.reload.completed_at }
            expect(exam.completed_at).to eq original_time
          end
        end
      end
    end

    describe "状態判定 (#completed?)" do
      it "completed_at があれば true を返すこと" do
        exam.completed_at = Time.current
        expect(exam.completed?).to be true
      end

      it "completed_at がなければ false を返すこと" do
        exam.completed_at = nil
        expect(exam.completed?).to be false
      end
    end

    describe "集計・採点ロジック" do
      before do
        questions = create_list(:question, 3, :with_choices)
        exam.attach_questions!(questions.pluck(:id))
        exam.reload

        q1 = exam.exam_questions.find_by(position: 1)
        correct_choice_1 = q1.question.question_choices.find_by(correct: true)
        q1.save_answers!([correct_choice_1.id])

        q2 = exam.exam_questions.find_by(position: 2)
        wrong_choice_2 = q2.question.question_choices.find_by(correct: false)
        q2.save_answers!([wrong_choice_2.id])
      end

      describe "#total_questions" do
        it "総問題数を返すこと" do
          expect(exam.total_questions).to eq 3
        end
      end

      describe "#answered_count" do
        it "回答済みの問題数を返すこと" do
          expect(exam.answered_count).to eq 2
        end
      end

      describe "#correct_count" do
        it "正解した問題数を返すこと" do
          expect(exam.correct_count).to eq 1
        end
      end

      describe "#score_percentage" do
        context "問題がある場合" do
          it "正答率（％）を小数点第1位まで計算して返すこと" do
            expect(exam.score_percentage).to eq 33.3
          end
        end

        context "問題が0問の場合（0除算対策）" do
          let(:empty_exam) { create(:exam, user: user) }

          it "0.0 を返すこと" do
            expect(empty_exam.score_percentage).to eq 0.0
          end
        end
      end
    end

    describe "合否判定 (#passed?)" do
      let(:questions) { create_list(:question, 10, :with_choices) }

      before do
        exam.attach_questions!(questions.pluck(:id))
        exam.reload
      end

      def answer_correctly(count)
        exam.exam_questions.limit(count).each do |eq|
          correct_choice = eq.question.question_choices.find_by(correct: true)
          eq.save_answers!([correct_choice.id])
        end
      end

      context "正答率が合格ライン(70%)に届かない場合" do
        it "false を返すこと (6問正解: 60%)" do
          answer_correctly(6)
          expect(exam.score_percentage).to eq 60.0
          expect(exam.passed?).to be false
        end
      end

      context "正答率が合格ライン(70%)以上の場合" do
        it "true を返すこと (7問正解: 70% - 境界値)" do
          answer_correctly(7)
          expect(exam.score_percentage).to eq 70.0
          expect(exam.passed?).to be true
        end

        it "true を返すこと (10問正解: 100%)" do
          answer_correctly(10)
          expect(exam.score_percentage).to eq 100.0
          expect(exam.passed?).to be true
        end
      end
    end
  end
end
