# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :require_login, only: %i[terms privacy]

  def terms
  end

  def privacy
  end
end
