# frozen_string_literal: true

class Exam::QuestionSelector
  TOTAL_QUESTIONS = 40

  ExamQuestionData = Data.define(:id, :chapter)

  def call
    selected_questions = select_questions(Category.order(:chapter_number))
    chapter_ordered_question_ids(selected_questions)
  end

  private
    def select_questions(categories)
      selected_questions = sample_based_on_weight(categories, total_weight(categories))
      adjust_remaining(selected_questions)
    end

    def chapter_ordered_question_ids(questions)
      group_by_chapter(questions)
        .sort_by { |chapter, _| chapter }
        .flat_map { |_chapter, questions| shuffled_question_ids(questions) }
    end

    def group_by_chapter(questions)
      questions.group_by(&:chapter)
    end

    def shuffled_question_ids(questions)
      questions.shuffle.map(&:id)
    end

    def adjust_remaining(selected_questions)
      selected_ids = selected_questions.map(&:id)
      remaining_count = TOTAL_QUESTIONS - selected_ids.count
      return selected_questions if remaining_count <= 0

      extra_questions = Question.where.not(id: selected_ids)
                                .joins(:category)
                                .select("questions.id, categories.chapter_number")
                                .sample(remaining_count)
                                .map { |q| ExamQuestionData.new(q.id, q.chapter_number) }

      selected_questions.concat(extra_questions)
    end

    def sample_based_on_weight(categories, total_weight)
      selected_questions = []
      return selected_questions if total_weight.zero?

      categories.each do |category|
        count = (TOTAL_QUESTIONS * category.weight / total_weight).floor
        next if count <= 0

        question_ids = category.questions.order("RANDOM()").limit(count).pluck(:id)
        question_ids.each do |q_id|
          selected_questions << ExamQuestionData.new(q_id, category.chapter_number)
        end
      end

      selected_questions
    end

    def total_weight(categories)
      categories.sum(&:weight).to_f
    end
end
