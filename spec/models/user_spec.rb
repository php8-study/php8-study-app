# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "ファクトリ" do
    it "有効なファクトリを持つこと" do
      expect(build(:user)).to be_valid
    end
  end

  describe "インスタンスメソッド" do
    let(:user) { create(:user) }

    describe "#active_exam" do
      context "進行中の試験がある場合" do
        let!(:exam) { create(:exam, user: user, completed_at: nil) }
        before { create(:exam, :completed, user: user) }

        it "進行中の試験を返すこと" do
          expect(user.active_exam).to eq(exam)
        end
      end

      context "完了済みの試験しかない場合" do
        before { create(:exam, :completed, user: user) }

        it "nil を返すこと" do
          expect(user.active_exam).to be_nil
        end
      end

      context "試験が1つもない場合" do
        it "nil を返すこと" do
          expect(user.active_exam).to be_nil
        end
      end
    end
  end
end
