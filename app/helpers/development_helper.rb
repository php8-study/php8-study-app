# frozen_string_literal: true

module DevelopmentHelper
  def development_users
    return User.none unless Rails.env.development?

    User.order(:id)
  end
end
