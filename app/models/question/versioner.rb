# frozen_string_literal: true

class Question::Versioner
  def initialize(old_question, params)
    @old_question = old_question
    @raw_params = params
  end

  def create_version!
    Question.transaction do
      @old_question.update_columns(deleted_at: Time.current)
      
      # .to_h でActionController::Parametersを標準ハッシュに変換
      new_params = params_for_new_version(@raw_params.to_h)

      Question.create!(new_params)
    end
  end

  private
    def params_for_new_version(params)
      params.deep_dup.tap do |p|
        prune_marked_for_destruction!(p)
        strip_ids!(p)
      end
    end

    def prune_marked_for_destruction!(hash)
      return unless hash.is_a?(Hash)

      hash.delete_if do |_, value|
        if value.is_a?(Hash) && marked_for_destruction?(value)
          true
        elsif value.is_a?(Hash)
          prune_marked_for_destruction!(value)
          false
        else
          false
        end
      end
    end

    def strip_ids!(hash)
      return unless hash.is_a?(Hash)

      hash.delete("id")
      hash.delete("_destroy")
      hash.delete(:id)
      hash.delete(:_destroy)

      hash.each_value do |value|
        strip_ids!(value) if value.is_a?(Hash)
      end
    end

    def marked_for_destruction?(hash)
      v = hash["_destroy"] || hash[:_destroy]
      v.to_s == "1"
    end
end
