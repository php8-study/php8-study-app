# frozen_string_literal: true

require "rails_helper"

RSpec.describe Question::Versioner, type: :model do
  let!(:old_question) { create(:question) }
  let!(:old_choice) { create(:question_choice, question: old_question) }

  let(:params) do
    ActionController::Parameters.new({
      content: "更新後の問題文",
      category_id: old_question.category_id,
      id: old_question.id,
      question_choices_attributes: [
        {
          id: old_choice.id,
          content: "削除したい選択肢",
          _destroy: "1"
        },
        {
          content: "新しく追加する選択肢",
          _destroy: "0"
        }
      ]
    }).permit!
  end

  let(:versioner) { described_class.new(old_question, params) }

  describe "#create_version!" do
    it "新しいバージョンの問題が作成されること" do
      expect { versioner.create_version! }.to change(Question, :count).by(1)
    end

    context "実行結果の検証" do
      let!(:new_question) { versioner.create_version! }

      it "古い問題は論理削除されること" do
        expect(old_question.reload.deleted_at).to be_present
      end

      it "削除フラグ(_destroy: 1)がついた選択肢は、新バージョンに含まれないこと" do
        expect(new_question.question_choices.count).to eq 1
        expect(new_question.question_choices.first.content).to eq "新しく追加する選択肢"
      end

      it "新バージョンにはIDが引き継がれず、新しいIDが採番されていること" do
        expect(new_question.id).not_to eq old_question.id
        expect(new_question.question_choices.first.id).not_to eq old_choice.id
      end
    end
  end
end
