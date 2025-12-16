# frozen_string_literal: true

require "rails_helper"

RSpec.describe Question, type: :model do
  describe "ファクトリ" do
    it "有効なファクトリを持つこと" do
      expect(build(:question)).to be_valid
    end
  end

  describe "スコープ" do
    describe ".active" do
      let!(:active_question) { create(:question) }
      let!(:archived_question) { create(:question, :archived) }

      it "deleted_at が nil のレコードのみ取得すること" do
        expect(described_class.active).to include(active_question)
        expect(described_class.active).not_to include(archived_question)
      end
    end
  end

  describe "削除ロジック (#safe_destroy)" do
    context "未使用の問題を削除する場合（物理削除）" do
      let!(:question) { create(:question) }

      it "レコード自体が削除され、true が返ること" do
        expect {
          result = question.safe_destroy
          expect(result).to be_truthy
        }.to change(Question, :count).by(-1)

        expect(Question.exists?(question.id)).to be false
      end
    end

    context "使用中の問題を削除する場合（論理削除）" do
      let!(:question) { create(:question, :in_use) }

      it "レコード数は減らず、deleted_at が更新され、true が返ること" do
        expect {
          result = question.safe_destroy
          expect(result).to be_truthy
        }.not_to change(Question, :count)

        expect(question.reload.deleted_at).to be_present
      end
    end
  end

  describe "更新ロジック (#safe_update)" do
    let(:category) { create(:category) }

    let(:valid_params) do
      { content: "更新後の問題文", category_id: category.id }
    end

    context "無効なパラメータの場合" do
      let(:question) { create(:question) }
      let(:invalid_params) { { content: "" } }

      it "更新されず false が返り、errors に内容が含まれること" do
        result = question.safe_update(invalid_params)

        expect(result).to be false
        expect(question.errors.of_kind?(:content, :blank)).to be true
        expect(question.reload.content).not_to eq ""
      end
    end

    context "未使用の問題を更新する場合（通常更新）" do
      let!(:question) { create(:question) }

      it "レコード数は増えず、自身の属性が更新され、自身のインスタンスが返ること" do
        expect {
          result = question.safe_update(valid_params)
          expect(result).to eq(question)
        }.not_to change(Question, :count)

        question.reload
        expect(question.content).to eq "更新後の問題文"
        expect(question.deleted_at).to be_nil
      end
    end

    context "使用中の問題を更新する場合（バージョン管理更新）" do
      let!(:question) { create(:question, :in_use) }

      it "新しいレコードが作成され、新しいインスタンスが返ること" do
        result = nil
        expect {
          result = question.safe_update(valid_params)
        }.to change(Question, :count).by(1)

        expect(result).to be_a(Question)
        expect(result.id).not_to eq question.id
        expect(result.content).to eq "更新後の問題文"

        expect(question.reload.deleted_at).to be_present
      end
    end
  end

  describe "インスタンスメソッド" do
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

    describe "正誤判定 (#correct_choice_ids / #answer_correct?)" do
      # with_choices trait で 正解1つ、不正解3つ が作成される
      # テスト用にさらに正解を1つ追加して、複数回答のケースを作る
      let(:question) { create(:question, :with_choices) }
      let!(:additional_correct_choice) { create(:question_choice, question: question, correct: true) }

      let(:correct_choices) { question.question_choices.where(correct: true) }
      let(:wrong_choice) { question.question_choices.find_by(correct: false) }

      describe "#correct_choice_ids" do
        it "正解の選択肢IDのみを昇順で返すこと" do
          expected_ids = correct_choices.pluck(:id).sort
          expect(question.correct_choice_ids).to eq(expected_ids)
        end
      end

      describe "#answer_correct?" do
        context "正解となる場合" do
          it "正解IDと完全に一致する場合は true" do
            input_ids = correct_choices.pluck(:id)
            expect(question.answer_correct?(input_ids)).to be true
          end

          it "IDの順序が異なっていても true" do
            input_ids = correct_choices.pluck(:id).reverse
            expect(question.answer_correct?(input_ids)).to be true
          end

          it "IDが文字列で渡されても true" do
            input_ids = correct_choices.pluck(:id).map(&:to_s)
            expect(question.answer_correct?(input_ids)).to be true
          end
        end

        context "不正解となる場合" do
          it "不正解の選択肢を選んでいる場合は false" do
            input_ids = [wrong_choice.id]
            expect(question.answer_correct?(input_ids)).to be false
          end

          it "正解と不正解が混ざっている場合は false" do
            input_ids = correct_choices.pluck(:id) + [wrong_choice.id]
            expect(question.answer_correct?(input_ids)).to be false
          end

          it "正解が不足している場合は false" do
            input_ids = [correct_choices.first.id]
            expect(question.answer_correct?(input_ids)).to be false
          end

          it "選択肢を選択していない場合は false" do
            expect(question.answer_correct?([])).to be false
          end

          it "nil が渡された場合は false" do
            expect(question.answer_correct?(nil)).to be false
          end
        end
      end
    end
  end
end
