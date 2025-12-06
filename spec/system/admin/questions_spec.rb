require 'rails_helper'

RSpec.describe "Admin::Questions", type: :system do
  let(:admin) { create(:user, :admin) }

  let!(:question) { create(:question, content: "古い問題文") }
  let!(:choice) { create(:question_choice, question: question, content: "古い選択肢") }

  before do
    sign_in_as(admin)
  end

  describe "問題の編集" do
    context "試験ですでに使用されている場合 (バージョン管理対象)" do
      before do
        create(:exam_question, question: question)
      end

      it "更新すると新しいバージョンが作成され、URL(ID)が変化する" do
        visit edit_admin_question_path(question)
        expect(page).to have_field "問題文", with: "古い問題文"

        fill_in "question[content]", with: "新しい問題文"
        fill_in "question[question_choices_attributes][0][content]", match: :first, with: "新しい選択肢"

        click_button "保存する"

        expect(page).to have_field "question[content]", with: "新しい問題文"
        expect(page).to have_field 'question[question_choices_attributes][0][content]', with: '新しい選択肢'
        expect(current_path).not_to eq edit_admin_question_path(question)
      end
    end

    context "試験で使用されていない場合 (通常更新)" do
      it "更新してもURL(ID)は変化しない" do
        visit edit_admin_question_path(question)

        fill_in "問題文", with: "単なる修正です"
        click_button "保存する"

        expect(page).to have_field "question[content]", with: "単なる修正です"
        expect(current_path).to eq edit_admin_question_path(question)
      end
    end
  end
end
