# frozen_string_literal: true

require "rails_helper"

RSpec.describe "StaticPages", type: :request do
  [
    { path: :terms_path,   title: "利用規約" },
    { path: :privacy_path, title: "プライバシーポリシー" },
  ].each do |page_info|
    describe "GET #{page_info[:path]}" do
      let(:target_path) { send(page_info[:path]) }

      it "正常に表示され、タイトルが含まれていること" do
        get target_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(page_info[:title])
      end
    end
  end
end
