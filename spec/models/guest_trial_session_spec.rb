# frozen_string_literal: true

require "rails_helper"

RSpec.describe GuestTrialSession, type: :model do
  let(:session) { {} }
  let(:user) { nil }
  let(:instance) { described_class.new(session, user) }

  describe "#allow?" do
    context "ログインユーザーの場合" do
      let(:user) { create(:user) }

      it "無条件で true を返す" do
        expect(instance.allow?(1)).to be true
      end

      it "セッションには何も記録されない" do
        instance.allow?(1)
        expect(session[:guest_viewed_question_ids]).to be_nil
      end
    end

    context "ゲストユーザーの場合" do
      let(:user) { nil }

      context "履歴がまだない場合" do
        it "true を返す" do
          expect(instance.allow?(1)).to be true
        end

        it "セッションに閲覧履歴が保存される" do
          expect { instance.allow?(1) }.to change { session[:guest_viewed_question_ids] }.from(nil).to(["1"])
        end
      end

      context "履歴が4件ある場合（5問目: 境界値）" do
        before { session[:guest_viewed_question_ids] = %w[1 2 3 4] }

        it "true を返す" do
          expect(instance.allow?(5)).to be true
        end

        it "セッションに履歴が追加され、計5件になる" do
          instance.allow?(5)
          expect(session[:guest_viewed_question_ids]).to eq %w[1 2 3 4 5]
        end
      end

      context "履歴が5件ある場合（6問目: 制限超過）" do
        before { session[:guest_viewed_question_ids] = %w[1 2 3 4 5] }

        context "新しい問題にアクセスする場合" do
          it "false を返す" do
            expect(instance.allow?(6)).to be false
          end

          it "セッションの履歴は増えない" do
            expect { instance.allow?(6) }.not_to change { session[:guest_viewed_question_ids] }
          end
        end

        context "既に見た問題に再度アクセスする場合" do
          it "true を返す（再閲覧は許可）" do
            expect(instance.allow?(1)).to be true
          end
        end
      end

      context "IDの型変換の確認" do
        it "Integerで渡しても、セッションにはStringとして保存される" do
          instance.allow?(10)
          expect(session[:guest_viewed_question_ids]).to include "10"
        end

        it "Stringで保存された履歴に対して、Integerで照合しても正しく判定される" do
          session[:guest_viewed_question_ids] = ["10"]

          expect(instance.allow?(10)).to be true
        end
      end
    end
  end
end
