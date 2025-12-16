# frozen_string_literal: true

require "rails_helper"

RSpec.describe Question::Versioner, type: :model do
  describe "#create_version!" do
    let(:category) { create(:category) }
    let!(:old_question) { create(:question, category: category, content: "古い問題文") }

    let!(:keep_choice) { create(:question_choice, question: old_question, content: "残す選択肢") }
    let!(:delete_choice) { create(:question_choice, question: old_question, content: "削除する選択肢") }

    let(:params) do
      ActionController::Parameters.new({
        id: old_question.id,
        content: "新しい問題文",
        category_id: category.id,
        question_choices_attributes: {
          "0" => {
            id: keep_choice.id,
            content: "更新された選択肢",
            _destroy: "0"
          },
          "1" => {
            id: delete_choice.id,
            content: "削除する選択肢",
            _destroy: "1"
          },
          "2" => {
            content: "新規追加された選択肢",
            _destroy: "0"
          }
        }
      }).permit!
    end

    let(:versioner) { described_class.new(old_question, params) }

    it "古い問題は論理削除(deleted_at更新)されること" do
      expect {
        versioner.create_version!
      }.to change { old_question.reload.deleted_at }.from(nil)
    end

    it "新しい問題(Question)が1つ作成されること" do
      expect {
        versioner.create_version!
      }.to change(Question, :count).by(1)
    end

    describe "作成された新しい問題の検証" do
      let(:new_question) { versioner.create_version! }

      it "IDは引き継がず、新しいIDが採番されていること" do
        expect(new_question.id).not_to eq old_question.id
        expect(new_question.persisted?).to be true
      end

      it "指定したパラメータ(content等)が反映されていること" do
        expect(new_question.content).to eq "新しい問題文"
        expect(new_question.category_id).to eq category.id
      end

      describe "ネストされた選択肢(QuestionChoice)の処理" do
        it "削除フラグ(_destroy: 1)の選択肢は除外され、残りと新規のみ作成されること" do
          expect(new_question.question_choices.size).to eq 2

          contents = new_question.question_choices.pluck(:content)
          expect(contents).to include("更新された選択肢")
          expect(contents).to include("新規追加された選択肢")
          expect(contents).not_to include("削除する選択肢")
        end

        it "選択肢のIDも一新されていること（ディープコピー）" do
          new_choice = new_question.question_choices.find_by(content: "更新された選択肢")

          expect(new_choice.id).not_to eq keep_choice.id
        end
      end
    end

    context "新しい問題の保存に失敗した場合" do
      before do
        params[:content] = ""
      end

      it "例外が発生し、古い問題の論理削除もロールバックされること" do
        expect {
          versioner.create_version!
        }.to raise_error(ActiveRecord::RecordInvalid)

        expect(old_question.reload.deleted_at).to be_nil
      end
    end
  end
end
