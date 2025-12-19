# frozen_string_literal: true

module Common
  module Flash
    class Component < ViewComponent::Base
      def initialize(flash:)
        @flash = flash
      end

      def render?
        @flash.any?
      end

      def notice?(key)
        key.to_s == "notice"
      end

      def icon_bg_class(key)
        notice?(key) ? "bg-emerald-50" : "bg-rose-50"
      end

      def icon_color_class(key)
        notice?(key) ? "text-emerald-600" : "text-rose-600"
      end

      def title_text(key)
        notice?(key) ? "Success" : "Error"
      end

      def icon_name(key)
        notice?(key) ? "check" : "caution"
      end

      def role_attr(key)
        notice?(key) ? "status" : "alert"
      end
    end
  end
end
