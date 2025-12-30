# frozen_string_literal: true

module Admin
  class ApplicationController < ::ApplicationController
    before_action :require_admin

  private
    def require_admin
      raise ActiveRecord::RecordNotFound unless current_user&.admin?
    end
  end
end
