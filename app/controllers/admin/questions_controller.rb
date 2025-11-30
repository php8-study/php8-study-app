# frozen_string_literal: true

class Admin::QuestionsController < AdminController
  before_action :set_question, only: [:edit, :update, :destroy]

  def index
    @questions = Question.includes(:category).all
  end

  def new
    @question = Question.new
    4.times { @question.question_choices.build }
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to admin_questions_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to admin_questions_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy

    respond_to do |format|
      format.html { redirect_to admin_questions_url, notice: "問題が削除されました。" }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@question) }
    end
  end

  private
    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(
        :content,
        :category_id,
        :explanation,
        :official_page,
        question_choices_attributes: [:id, :content, :correct, :_destroy]
      )
    end
end
