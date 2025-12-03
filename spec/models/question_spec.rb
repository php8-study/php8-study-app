# frozen_string_literal: true

require "rails_helper"

RSpec.describe Question, type: :model do
  describe "#build_default_choices" do
    let(:question) { Question.new }

    context "選択肢がまだない場合" do
      it "デフォルトの数で選択肢をビルドすること" do
        question.build_default_choices
        expect(question.question_choices.size).to eq(Question::DEFAULT_CHOICES_COUNT)
      end
    end

    context "既に選択肢がある場合" do
      before do
        question.question_choices.build(content: "既存")
      end

      it "新たに選択肢を追加しないこと" do
        question.build_default_choices
        expect(question.question_choices.size).to eq(1)
      end
    end
  end

  describe "正誤判定ロジック" do
    let(:question) { create(:question) }
    let!(:correct_choice_1) { create(:question_choice, question: question, correct: true) }
    let!(:correct_choice_2) { create(:question_choice, question: question, correct: true) }
    let!(:wrong_choice) { create(:question_choice, question: question, correct: false) }

    describe "#correct_choice_ids" do
      it "正解の選択肢IDのみを昇順で返すこと" do
        expect(question.correct_choice_ids).to eq([correct_choice_1.id, correct_choice_2.id].sort)
      end
    end

    describe "#answer_correct?" do
      subject { question.answer_correct?(input_ids) }

      context "正解となる場合" do
        context "正解と完全に一致する場合" do
          let(:input_ids) { [correct_choice_1.id, correct_choice_2.id] }
          it { is_expected.to be true }
        end

        context "正解と同じIDだが、IDの順序が異なっている場合" do
          let(:input_ids) { [correct_choice_2.id, correct_choice_1.id] }
          it { is_expected.to be true }
        end

        context "正解のIDが文字列で渡された場合" do
          let(:input_ids) { [correct_choice_1.id.to_s, correct_choice_2.id.to_s] }
          it { is_expected.to be true }
        end
      end

      context "不正解となる場合" do
        context "不正解の選択肢を選んでいる場合" do
          let(:input_ids) { [wrong_choice.id] }
          it { is_expected.to be false }
        end

        context "正解と不正解が混ざっている場合" do
          let(:input_ids) { [correct_choice_1.id, wrong_choice.id] }
          it { is_expected.to be false }
        end

        context "正解が不足している場合" do
          let(:input_ids) { [correct_choice_1.id] }
          it { is_expected.to be false }
        end

        context "選択肢を選択していない場合" do
          let(:input_ids) { [] }
          it { is_expected.to be false }
        end
      end
    end
  end
end
