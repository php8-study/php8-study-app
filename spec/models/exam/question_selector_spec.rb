# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exam::QuestionSelector, type: :model do
  describe "#call" do
    let(:selector) { described_class.new }

    let(:category1) { create(:category, chapter_number: 1, weight: 10) }
    let(:category2) { create(:category, chapter_number: 2, weight: 10) }

    context "十分な数の問題がある場合" do
      before do
        create_list(:question, 25, category: category1)
        create_list(:question, 25, category: category2)
      end

      it "合計数が定数(TOTAL_QUESTIONS)と一致すること" do
        result_ids = selector.call
        expect(result_ids.count).to eq Exam::QuestionSelector::TOTAL_QUESTIONS
      end

      it "チャプター順（昇順）に並んでいること" do
        result_ids = selector.call

        questions_map = Question.where(id: result_ids)
                                .preload(:category)
                                .index_by(&:id)

        result_chapters = result_ids.map { |id| questions_map[id].category.chapter_number }

        half_count = result_ids.size / 2
        first_half = result_chapters.first(half_count)
        second_half = result_chapters.last(half_count)

        expect(first_half).to all(eq 1)
        expect(second_half).to all(eq 2)
      end

      it "重み付けに従って配分されること（等しい重みなら等しい数）" do
        result_ids = selector.call
        questions = Question.where(id: result_ids)

        count_cat1 = questions.where(category_id: category1.id).count
        count_cat2 = questions.where(category_id: category2.id).count

        expect(count_cat1).to eq count_cat2

        expect(count_cat1 + count_cat2).to eq Exam::QuestionSelector::TOTAL_QUESTIONS
      end
    end

    context "重みによる配分で端数が出る場合" do
      # カテゴリ1(重み10), カテゴリ2(重み20) -> 1:2
      # 全40問 -> 13.33問 : 26.66問 -> floorして 13 : 26 (計39)
      # 残り1問が adjust_remaining で埋められる
      let(:category1) { create(:category, chapter_number: 1, weight: 10) }
      let(:category2) { create(:category, chapter_number: 2, weight: 20) }

      before do
        create_list(:question, 20, category: category1)
        create_list(:question, 30, category: category2)
      end

      it "不足分が補充され、合計数が仕様通りになること" do
        result_ids = selector.call
        expect(result_ids.count).to eq Exam::QuestionSelector::TOTAL_QUESTIONS
      end

      it "配分がおおよそ 1:2 になっていること" do
        result_ids = selector.call
        questions = Question.where(id: result_ids)

        count_cat1 = questions.where(category_id: category1.id).count
        count_cat2 = questions.where(category_id: category2.id).count

        expected_cat1 = Exam::QuestionSelector::TOTAL_QUESTIONS / 3

        expect(count_cat1).to be_within(1).of(expected_cat1)

        expect(count_cat1 + count_cat2).to eq Exam::QuestionSelector::TOTAL_QUESTIONS
      end
    end

    context "問題数が不足している場合" do
      before do
        create_list(:question, 5, category: category1)
        create_list(:question, 5, category: category2)
      end

      it "存在する全問題のIDを返すこと" do
        result_ids = selector.call
        expect(result_ids.count).to eq 10
      end
    end

    context "論理削除された問題が含まれる場合" do
      let!(:active_q) { create(:question, category: category1) }
      let!(:archived_q) { create(:question, :archived, category: category1) }

      it "activeな問題のみ選定されること" do
        result_ids = selector.call

        expect(result_ids).to include(active_q.id)
        expect(result_ids).not_to include(archived_q.id)
      end
    end
  end
end
