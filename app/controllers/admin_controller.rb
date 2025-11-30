# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :require_admin

  private
    def require_admin
      raise ActiveRecord::RecordNotFound unless current_user&.admin?
    end
end
