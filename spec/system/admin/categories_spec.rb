# frozen_string_literal: true

require "rails_helper"

RSpec.describe "カテゴリーの管理画面", type: :system do
  let(:admin) { create(:user, :admin) }
  let!(:category) { create(:category, name: "テストカテゴリー") }

  before do
    sign_in_as(admin)
    visit admin_categories_path
    expect(page).to have_content "カテゴリー管理"
  end

  describe "一覧表示" do
    it "カテゴリー一覧が表示され、アクションボタンが存在すること" do
      expect(page).to have_content "テストカテゴリー"
      expect(page).to have_link "新規作成", href: new_admin_category_path
      expect(page).to have_link "管理トップ", href: admin_root_path

      within "#category_#{category.id}" do
        expect(page).to have_selector "a[title='編集']"
        expect(page).to have_selector "a[title='削除']"
      end
    end
  end

  describe "新規作成" do
    before do
      click_link "新規作成"
      expect(page).to have_content "カテゴリー新規作成"
    end
    context "登録情報に過不足が無い場合" do
      it "正しく作成できる" do
        fill_in "category[name]", with: "新しいカテゴリー"
        fill_in "category[chapter_number]", with: "99"
        fill_in "category[weight]", with: "20"

        click_button "保存する"

        expect(page).to have_content "カテゴリーを作成しました"
        expect(page).to have_content "新しいカテゴリー"
      end
    end

    context "登録情報に過不足がある場合" do
      it "エラーが出て作成できない" do
        execute_script("document.querySelector('form').noValidate = true")

        click_button "保存する"

        # TODO i18n導入で日本語化することを検討する ユーザーは触れない場所なので今はそのまま
        expect(page).to have_content "Name can't be blank"
        expect(page).to have_content "Chapter number can't be blank"
        expect(page).to have_content "Chapter number is not a number"
      end
    end

    context "キャンセルした場合" do
      it "カテゴリー管理ページに戻る" do
        click_link "キャンセル"
        expect(page).to have_current_path(admin_categories_path)
      end
    end
  end

  describe "編集" do
    before do
      within "#category_#{category.id}" do
        find("a[title='編集']").click
      end
      expect(page).to have_selector("form[action*='/admin/categories/#{category.id}']")
    end

    context "値を変更して保存した場合" do
      it "表記が変更される" do
        fill_in "category[name]", with: "編集後のカテゴリー"
        click_button "保存"

        expect(page).to have_content "編集後のカテゴリー"
        expect(page).not_to have_content "テストカテゴリー"
      end
    end

    context "無効な値を入力して保存した場合" do
      it "更新されずエラーが表示される" do
        execute_script("document.querySelector('form').noValidate = true")

        fill_in "category[name]", with: ""
        click_button "保存"

        # TODO i18n導入で日本語化することを検討する ユーザーは触れない場所なので今はそのまま
        expect(page).to have_content "Name can't be blank"
        expect(page).to have_field "category[name]", with: ""
      end
    end

    context "値を変更せず保存した場合" do
      it "対象のカテゴリの表記はそのまま" do
        click_button "保存"

        expect(page).to have_content "テストカテゴリー"
      end
    end

    context "キャンセルした場合" do
      it "編集モードが終了し、元の表記に戻る" do
        fill_in "category[name]", with: "変えようとしたけどやめる"
        click_link "キャンセル"

        expect(page).to have_content "テストカテゴリー"
        expect(page).not_to have_content "変えようとしたけどやめる"
      end
    end
  end


  describe "削除" do
    context "紐づく問題がない場合 (削除可能)" do
      it "削除に成功し、一覧から行が消える" do
        accept_confirm do
          find("a[title='削除']").click
        end

        expect(page).to have_content "カテゴリー「テストカテゴリー」を削除しました"
        expect(page).to have_no_selector("#category_#{category.id}")
      end
    end

    context "紐づく問題がある場合 (削除不可)" do
      before do
        create(:question, category: category)
      end

      it "削除に失敗し、エラーが表示され、行は画面に残ったままになる" do
        accept_confirm do
          find("a[title='削除']").click
        end

        expect(page).to have_content "削除できません：紐付く問題が存在します"
        expect(page).to have_selector("#category_#{category.id}")
        expect(page).to have_content "テストカテゴリー"
      end
    end
  end
end
