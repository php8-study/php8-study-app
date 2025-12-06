# frozen_string_literal: true

class Admin::QuestionsController < AdminController
  before_action :set_question, only: [:edit, :update, :destroy]

  def index
    @questions = Question.includes(:category).all
  end

  def new
    @question = Question.new
    @question.build_default_choices
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to admin_questions_path, notice: "問題を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @new_question = @question.update_or_version(question_params)
      redirect_to edit_admin_question_path(@new_question), notice: "問題を保存しました"
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

    def update_as_new_version
      if save_as_new_version
        redirect_to admin_questions_path, notice: "問題は受験履歴があるため、履歴を保持したまま新しい問題として作成されました。"
      else
        render :edit, status: :unprocessable_entity
      end
    end
end
