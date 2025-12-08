require 'rails_helper'

RSpec.describe "Exams", type: :system do
  let(:user) { create(:user) }
  let!(:category) { create(:category, name: "基礎知識") }
  
  let!(:questions) do
    create_list(:question, 2, :with_choices, category: category)
  end

  before do
    sign_in_as(user)
  end

  describe "試験の新規作成と破棄" do
    context "中断中の試験データが存在する場合" do
      let!(:old_exam) { create(:exam, user: user) }

      it "既存の試験を破棄して、新しい試験を開始できること" do
        visit root_path
        click_link "模擬試験を受験する"

        accept_confirm("本当に現在の進捗を破棄してよろしいですか？") do
          click_button "破棄して新規開始"
        end

        expect(page).to have_current_path(%r{/exams/\d+/exam_questions/\d+})
        expect(current_path).not_to include("/exams/#{old_exam.id}/")
      end
    end
  end

  describe "回答状況一覧（グリッド表示）" do
    before do
      visit root_path
      click_link "模擬試験を受験する"
      
      expect(page).to have_current_path(%r{/exams/\d+/exam_questions/\d+})

      @current_exam = Exam.last
      @q1_record = @current_exam.exam_questions.find_by(position: 1)
      @q2_record = @current_exam.exam_questions.find_by(position: 2)

      answer_question(@q1_record, correct: true)
      
      click_button "回答する"

      expect(page).to have_current_path(%r{/exams/#{@current_exam.id}/exam_questions/#{@q2_record.id}})

      click_link "回答状況一覧へ" 
    end

    it "各問題のステータスに応じたスタイルが適用されていること", :aggregate_failures do
      link_1 = find("a[href*='/exam_questions/#{@q1_record.id}'].h-20")
      expect(link_1[:class]).to include("bg-indigo-50")

      link_2 = find("a[href*='/exam_questions/#{@q2_record.id}'].h-20")
      expect(link_2[:class]).to include("bg-white")
    end

    it "問題番号をクリックすると、その問題の回答画面へ遷移すること" do
      find("span.text-2xl.font-black", text: "1").click

      expect(page).to have_current_path(%r{/exams/#{@current_exam.id}/exam_questions/#{@q1_record.id}})
      expect(page).to have_content @q1_record.question.content
    end
  end

  def answer_question(exam_question, correct:)
    target_choice = exam_question.question.question_choices.find_by(correct: correct)
    check target_choice.content
    expect(page).to have_checked_field(target_choice.content)
  end
end
