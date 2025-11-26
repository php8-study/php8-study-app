# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    render :landing unless current_user
  end
end
