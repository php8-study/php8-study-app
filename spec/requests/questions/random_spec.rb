# frozen_string_literal: true

# 権限違反・不正操作は一律で 404 を返す。

require "rails_helper"

RSpec.describe "Questions::Random", type: :request do
  let(:user) { create(:user) }
  let!(:question) { create(:question, :with_choices) }

  describe "GET /questions/random" do
    context "ログインしている場合" do
      before { sign_in_as(user) }

      context "利用可能な問題が存在する場合" do
        it "ランダムに選ばれた問題詳細ページへリダイレクトする" do
          get questions_random_path
          expect(response).to redirect_to(%r{/questions/\d+})
        end
      end

      context "利用可能な問題が1つもない場合" do
        before do
          Question.update_all(deleted_at: Time.current)
        end

        it "ルートパスへリダイレクトされ、アラートが表示される" do
          get questions_random_path

          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq "現在利用可能な問題がありません"
        end
      end
    end

    context "未ログインの場合" do
      context "利用可能な問題が存在する場合" do
        it "問題詳細ページへリダイレクトする（お試し機能）" do
          get questions_random_path
          expect(response).to redirect_to(%r{/questions/\d+})
        end
      end
      
      context "利用可能な問題が1つもない場合" do
        before do
          Question.update_all(deleted_at: Time.current)
        end

        it "ルートパスへリダイレクトされ、アラートが表示される" do
          get questions_random_path

          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq "現在利用可能な問題がありません"
        end
      end
    end
  end
end
