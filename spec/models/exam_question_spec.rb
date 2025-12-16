# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExamQuestion, type: :model do
  describe "ファクトリ" do
    it "有効なファクトリを持つこと" do
      expect(build(:exam_question)).to be_valid
    end
  end

  describe "ナビゲーション (#next_question / #previous_question)" do
    let(:exam) { create(:exam) }
    let!(:q1) { create(:exam_question, exam: exam, position: 1) }
    let!(:q2) { create(:exam_question, exam: exam, position: 2) }
    let!(:q3) { create(:exam_question, exam: exam, position: 3) }

    describe "#next_question" do
      it "次の position を持つ問題を返すこと" do
        expect(q1.next_question).to eq q2
        expect(q2.next_question).to eq q3
      end

      it "次の問題がない場合は nil を返すこと" do
        expect(q3.next_question).to be_nil
      end
    end

    describe "#previous_question" do
      it "前の position を持つ問題を返すこと" do
        expect(q3.previous_question).to eq q2
        expect(q2.previous_question).to eq q1
      end

      it "前の問題がない場合は nil を返すこと" do
        expect(q1.previous_question).to be_nil
      end
    end
  end

  describe "回答保存ロジック (#save_answers!)" do
    let(:exam_question) { create(:exam_question) }
    let(:question) { exam_question.question }

    let!(:choice_1) { create(:question_choice, question: question) }
    let!(:choice_2) { create(:question_choice, question: question) }

    let(:other_choice) { create(:question_choice) }

    context "有効な選択肢IDが渡された場合" do
      it "回答(ExamAnswer)が作成され、回答済み(answered?)ステータスになること" do
        exam_question.save_answers!([choice_1.id])
        exam_question.exam_answers.reload

        expect(exam_question.exam_answers.count).to eq 1
        expect(exam_question.user_choice_ids).to include(choice_1.id)
        expect(exam_question.answered?).to be true
      end

      it "複数回答も保存できること" do
        exam_question.save_answers!([choice_1.id, choice_2.id])
        exam_question.exam_answers.reload

        expect(exam_question.exam_answers.count).to eq 2
        expect(exam_question.user_choice_ids).to match_array([choice_1.id, choice_2.id])
      end

      it "既に回答がある場合は、一度削除して上書きされること" do
        exam_question.save_answers!([choice_1.id])
        exam_question.exam_answers.reload

        expect {
          exam_question.save_answers!([choice_2.id])
        }.not_to change(ExamAnswer, :count)
        exam_question.exam_answers.reload

        expect(exam_question.user_choice_ids).to eq [choice_2.id]
        expect(exam_question.user_choice_ids).not_to include(choice_1.id)
      end

      it "空配列を渡すと回答がクリアされ、未回答(answered? false)に戻ること" do
        exam_question.save_answers!([choice_1.id])
        exam_question.exam_answers.reload
        expect(exam_question.answered?).to be true

        exam_question.save_answers!([])
        expect(exam_question.exam_answers).to be_empty
        expect(exam_question.answered?).to be false
      end
    end

    context "不正な選択肢IDが含まれる場合" do
      it "RecordNotFound 例外が発生し、保存されないこと" do
        input_ids = [choice_1.id, other_choice.id]

        expect {
          exam_question.save_answers!(input_ids)
        }.to raise_error(ActiveRecord::RecordNotFound)

        expect(exam_question.exam_answers).to be_empty
      end
    end
  end

  describe "正誤判定 (#correct?)" do
    let(:question) { create(:question) }
    let(:exam_question) { create(:exam_question, question: question) }

    let!(:correct_choice_1) { create(:question_choice, question: question, correct: true) }
    let!(:correct_choice_2) { create(:question_choice, question: question, correct: true) }
    let!(:wrong_choice) { create(:question_choice, question: question, correct: false) }

    context "単一選択（または複数正解の一部）の場合" do
      it "正解の選択肢と完全に一致していないと false になること（不足）" do
        exam_question.save_answers!([correct_choice_1.id])
        exam_question.exam_answers.reload
        expect(exam_question.correct?).to be false
      end
    end

    context "完全一致の場合" do
      it "全ての正解選択肢を選んでいる場合は true になること" do
        exam_question.save_answers!([correct_choice_1.id, correct_choice_2.id])
        exam_question.exam_answers.reload
        expect(exam_question.correct?).to be true
      end
    end

    context "不正解を含む場合" do
      it "不正解の選択肢を選んでいる場合は false になること" do
        exam_question.save_answers!([wrong_choice.id])
        exam_question.exam_answers.reload
        expect(exam_question.correct?).to be false
      end
    end

    context "未回答の場合" do
      it "false になること" do
        expect(exam_question.correct?).to be false
      end
    end
  end
end
