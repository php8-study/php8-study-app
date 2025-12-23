# frozen_string_literal: true

class Common::Tooltip::Component < ViewComponent::Base
  def initialize(classes: nil)
    @classes = classes
  end
end
