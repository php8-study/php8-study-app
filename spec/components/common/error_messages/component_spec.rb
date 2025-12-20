# frozen_string_literal: true

require "rails_helper"

RSpec.describe Common::ErrorMessages::Component, type: :component do
  before do
    stub_const("TestModel", Class.new do
      include ActiveModel::Model
      attr_accessor :name
      validates :name, presence: true
    end)
  end

  context "エラーがある場合" do
    it "エラーメッセージが表示されること" do
      object = TestModel.new(name: "")
      object.validate

      render_inline(described_class.new(object: object))

      expect(page).to have_content("1件のエラーがあります")
      expect(page).to have_content("Nameを入力してください")
      expect(page).to have_selector(".bg-red-50")
    end
  end

  context "エラーがない場合" do
    it "何も表示されないこと" do
      object = TestModel.new(name: "正しい値")
      object.validate

      render_inline(described_class.new(object: object))

      expect(page.text).to be_empty
      expect(page).not_to have_selector("div")
    end
  end
end
