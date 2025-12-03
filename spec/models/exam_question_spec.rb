# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExamQuestion, type: :model do
  let(:question) { create(:question, :with_choices) }
  let(:correct_choice) { question.question_choices.find_by(correct: true) }
  let(:wrong_choice) { question.question_choices.find_by(correct: false) }
  let(:exam_question) { create(:exam_question, question: question) }

  describe "#save_answers!" do
    context "まだ回答がない場合" do
      it "指定した選択肢IDでExamAnswerが作成されること" do
        exam_question.save_answers!([correct_choice.id])
        expect(exam_question.exam_answers.reload.pluck(:question_choice_id)).to eq([correct_choice.id])
      end
    end

    context "既に回答が存在する場合" do
      before do
        exam_question.save_answers!([wrong_choice.id])
      end

      it "新しいIDを渡すと、回答が置き換わること" do
        exam_question.save_answers!([correct_choice.id])
        expect(exam_question.exam_answers.reload.pluck(:question_choice_id)).to eq([correct_choice.id])
      end

      it "空配列を渡すと、回答が削除されること" do
        exam_question.save_answers!([])
        expect(exam_question.exam_answers.reload).to be_empty
      end
    end
  end

  describe "#correct?" do
    subject { exam_question.reload.correct? }

    context "正解の選択肢を選んでいる場合" do
      before { exam_question.save_answers!([correct_choice.id]) }

      it { is_expected.to be true }
    end

    context "不正解の選択肢を選んでいる場合" do
      before { exam_question.save_answers!([wrong_choice.id]) }

      it { is_expected.to be false }
    end

    context "正解と不正解を両方選んでいる場合" do
      before { exam_question.save_answers!([correct_choice.id, wrong_choice.id]) }

      it { is_expected.to be false }
    end

    context "回答が無い場合" do
      before { exam_question.save_answers!([]) }

      it { is_expected.to be false }
    end
  end

  describe "#answered?" do
    subject { exam_question.reload.answered? }
    context "回答が存在する場合" do
      before { exam_question.save_answers!([correct_choice.id]) }

      it { is_expected.to be true }
    end

    context "回答が存在しない場合" do
      before { exam_question.exam_answers.destroy_all }

      it { is_expected.to be false }
    end
  end

  describe "#user_choice_ids" do
    subject { exam_question.reload.user_choice_ids }

    context "回答がある場合" do
      before { exam_question.save_answers!([correct_choice.id, wrong_choice.id]) }
      let(:expected_ids) { [correct_choice.id, wrong_choice.id].sort }

      it { is_expected.to eq(expected_ids) }
    end

    context "回答がない場合" do
      it { is_expected.to eq([]) }
    end
  end

  describe "ナビゲーションメソッド (#next_question, #previous_question)" do
    let(:exam_for_nav) { create(:exam) }
    let!(:q1) { create(:exam_question, exam: exam_for_nav, position: 1) }
    let!(:q2) { create(:exam_question, exam: exam_for_nav, position: 2) }
    let!(:q3) { create(:exam_question, exam: exam_for_nav, position: 3) }

    describe "#next_question" do
      it "次の順序の問題を返すこと" do
        expect(q1.next_question).to eq(q2)
      end

      it "最後の問題の場合は nil を返すこと" do
        expect(q3.next_question).to be_nil
      end
    end

    describe "#previous_question" do
      it "前の順序の問題を返すこと" do
        expect(q3.previous_question).to eq(q2)
      end

      it "最初の問題の場合は nil を返すこと" do
        expect(q1.previous_question).to be_nil
      end
    end
  end
end
