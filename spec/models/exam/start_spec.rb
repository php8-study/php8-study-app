# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exam::Start do
  describe "#call" do
    let(:user) { create(:user) }
    let(:service_call) { described_class.new(user: user).call }
    let(:questions) { create_list(:question, 3) }
    let(:question_ids) { questions.map(&:id) }
    let(:selector_instance) { instance_double(Exam::QuestionSelector, call: question_ids) }

    before do
      allow(Exam::QuestionSelector).to receive(:new).and_return(selector_instance)
    end

    context "正常系" do
        context "実行中の試験が既に存在する場合" do
          let!(:old_exam) { create(:exam, user: user, completed_at: nil) }

          it "古い試験を破棄すること" do
            service_call
            expect(Exam.exists?(old_exam.id)).to be false
          end

          it "新しい試験を作成すること" do
            new_exam = service_call
            expect(new_exam).to be_a(Exam)
          end

          it "試験の総数は変わらないこと" do
            expect { service_call }.not_to change(Exam, :count)
          end
        end

        context "実行中の試験がない場合" do
            it "新しい試験を一つ作成すること" do
              expect { service_call }.to change(Exam, :count).by(1)
            end
          end

        it "作成された試験に問題が正しく紐付けられていること" do
          new_exam = service_call

          expect(new_exam.exam_questions.count).to eq(3)
          expect(new_exam.exam_questions.pluck(:question_id)).to match_array(question_ids)
        end
      end

    context "異常系: 途中でエラーが発生した場合" do
      let!(:old_exam) { create(:exam, user: user, completed_at: nil) }

      before do
        allow_any_instance_of(Exam).to receive(:attach_questions!).and_raise(ActiveRecord::RecordInvalid)
      end

      it "トランザクションがロールバックされ、古い試験が削除されないこと" do
        expect { service_call }.to raise_error(ActiveRecord::RecordInvalid)
        expect(Exam.exists?(old_exam.id)).to be true
        expect(Exam.count).to eq(1)
      end
    end
  end
end
