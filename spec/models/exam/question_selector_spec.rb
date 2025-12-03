require 'rails_helper'

RSpec.describe Exam::QuestionSelector do
  describe '#call' do
    let(:selected_ids) { described_class.new.call }
    let!(:category_heavy) { create(:category, chapter_number: 1, weight: 80.0) }
    let!(:category_light) { create(:category, chapter_number: 2, weight: 20.0) }

    context '問題数が十分に存在する場合' do
      before do
        create_list(:question, 50, category: category_heavy)
        create_list(:question, 50, category: category_light)
      end

      it '合計で40問の問題IDが返されること' do
        expect(selected_ids.count).to eq(40)
      end

      it '重みに応じて問題数が配分されること' do
        selected_questions = Question.where(id: selected_ids)
        heavy_count = selected_questions.where(category: category_heavy).count
        light_count = selected_questions.where(category: category_light).count

        expect(heavy_count).to be_within(2).of(32)
        expect(light_count).to be_within(2).of(8)
      end

      it 'カテゴリの章番号順にソートされていること' do
        questions_by_id = Question.where(id: selected_ids)
                          .includes(:category)
                          .index_by(&:id)
        ordered_questions = selected_ids.map { |id| questions_by_id[id] }
        chapters = ordered_questions.map { |q| q.category.chapter_number }

        expect(chapters).to eq(chapters.sort)
      end
    end

    context '特定カテゴリの問題数が不足している場合' do
      before do
        create_list(:question, 5, category: category_heavy)
        create_list(:question, 100, category: category_light)
      end

      it '不足分を他から補って40問返すこと' do
        expect(selected_ids.count).to eq(40)
      end

      it '不足しているカテゴリの問題は全て選ばれていること' do
        selected_questions = Question.where(id: selected_ids)
        heavy_count = selected_questions.where(category: category_heavy).count

        expect(heavy_count).to eq(5)
      end
    end

    context 'そもそも問題総数が40問未満の場合' do
      before do
        create_list(:question, 10, category: category_heavy)
        create_list(:question, 10, category: category_light)
      end

      it '存在する全問題を返し、エラーにならないこと' do
        expect(selected_ids.count).to eq(20)
      end
    end
  end
end
