# frozen_string_literal: true

class Question::Versioner
  def initialize(old_question, params)
    @old_question = old_question
    @raw_params = params
  end

  def create_version!
    @old_question.update_columns(deleted_at: Time.current)
    new_params = params_for_new_version(@raw_params.to_h)

    Question.create!(new_params)
  end

  private
    def params_for_new_version(params)
      params.deep_dup.tap do |p|
        prune_marked_for_destruction!(p)
        strip_ids!(p)
      end
    end

    def prune_marked_for_destruction!(obj)
      case obj
      when Hash
        obj.delete_if do |_, value|
          if value.is_a?(Hash) && marked_for_destruction?(value)
            true
          else
            prune_marked_for_destruction!(value)
            false
          end
        end
      when Array

        obj.reject! { |el| el.is_a?(Hash) && marked_for_destruction?(el) }
        obj.each { |el| prune_marked_for_destruction!(el) }
      end
    end

    def strip_ids!(obj)
      case obj
      when Hash
        obj.delete("id")
        obj.delete("_destroy")
        obj.delete(:id)
        obj.delete(:_destroy)
        obj.each_value { |v| strip_ids!(v) }
      when Array
        obj.each { |v| strip_ids!(v) }
      end
    end

    def marked_for_destruction?(hash)
      v = hash["_destroy"] || hash[:_destroy]
      v.to_s == "1"
    end
end
