# frozen_string_literal: true

class Question::Versioner
  def initialize(old_question, params)
    @old_question = old_question
    @params = params
  end

  def create!
    @old_question.update_columns(deleted_at: Time.current)
    clean_params = strip_ids_from_params(@params.to_h)
    Question.create!(clean_params)
  end

  private
    def strip_ids_from_params(params)
      params.deep_dup.tap do |p|
        remove_keys_recursively(p)
      end
    end

    def remove_keys_recursively(obj)
      case obj
      when Hash
        obj.delete("id")
        obj.delete("_destroy")
        obj.each_value { |v| remove_keys_recursively(v) }
      when Array
        obj.each { |v| remove_keys_recursively(v) }
      end
    end
end
