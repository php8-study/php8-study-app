# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "ファクトリ" do
    it "有効なファクトリを持つこと" do
      expect(build(:user)).to be_valid
    end
  end

  describe "バリデーション" do
    context "github_id" do
      it "存在すれば有効なこと" do
        user = build(:user, github_id: "12345678")
        expect(user).to be_valid
      end

      it "空であれば無効なこと" do
        user = build(:user, github_id: nil)
        user.valid?
        expect(user.errors.of_kind?(:github_id, :blank)).to be true
      end

      it "重複していれば無効なこと" do
        create(:user, github_id: "12345678")
        user = build(:user, github_id: "12345678")
        user.valid?
        expect(user.errors.of_kind?(:github_id, :taken)).to be true
      end
    end
  end

  describe "DB制約" do
    it "github_id が重複するレコードを保存しようとすると一意性制約違反が発生すること" do
      create(:user, github_id: "12345678")
      user = build(:user, github_id: "12345678")

      expect {
        user.save!(validate: false)
      }.to raise_error(ActiveRecord::StatementInvalid)
    end
  end

  describe "デフォルト値" do
    it "admin はデフォルトで false であること" do
      user = create(:user)
      expect(user.admin).to be false
    end
  end

  describe "関連付け" do
    describe "has_many :exams" do
      let(:user) { create(:user) }
      let!(:exam) { create(:exam, user: user) }

      it "ユーザーが削除された場合、紐付く試験も削除されること" do
        # UIに削除機能はないが、dependent: :destroy が設定されていることを保証する
        user.destroy
        expect(Exam.exists?(exam.id)).to be false
      end
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

    describe "#discard_active_exam" do
      context "進行中の試験がある場合" do
        let!(:exam) { create(:exam, user: user, completed_at: nil) }
        let!(:exam_question) { create(:exam_question, exam: exam) }
        let!(:exam_answer) { create(:exam_answer, exam_question: exam_question) }

        it "試験および関連データ（問題・回答）を削除すること" do
          user.discard_active_exam

          expect(Exam.exists?(exam.id)).to be false
          expect(ExamQuestion.exists?(exam_question.id)).to be false
          expect(ExamAnswer.exists?(exam_answer.id)).to be false
        end
      end

      context "進行中の試験がない場合" do
        before { create(:exam, :completed, user: user) }

        it "何もせずエラーにならないこと" do
          expect { user.discard_active_exam }.not_to raise_error
        end
      end

      context "削除中にDBエラーが発生した場合" do
        let!(:exam) { create(:exam, user: user, completed_at: nil) }

        before do
          allow(user).to receive(:active_exam).and_return(exam)
          allow(exam).to receive(:destroy!).and_raise(ActiveRecord::ActiveRecordError, "DB Error")
        end

        it "例外を発生させず、Railsロガーにエラーを出力すること" do
          expect(Rails.logger).to receive(:error).with(/Failed to discard active exam/)
          expect { user.discard_active_exam }.not_to raise_error
        end
      end
    end
  end
end
