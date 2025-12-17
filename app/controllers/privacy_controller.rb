# frozen_string_literal: true

class PrivacyController < ApplicationController
  skip_before_action :require_login, only: %i[show]

  def show
  end
end
