# frozen_string_literal: true

class Admin::QuestionsController < AdminController
  before_action :set_question, only: [:edit, :update, :destroy]

  def index
    @questions = Question.includes(:category).active.order(created_at: :desc)
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
    if @question.destroy
      respond_to do |format|
        format.html { redirect_to admin_questions_path, notice: "問題を削除しました" }
        format.turbo_stream do
          flash.now[:notice] = "問題を削除しました"
          render turbo_stream: [
            turbo_stream.remove(@question),
            turbo_stream.update("flash", partial: "layouts/flash")
          ]
        end
      end
    else
      flash.now[:alert] = "削除できません：#{@question.errors.full_messages.join(', ')}"
      render turbo_stream: turbo_stream.update("flash", partial: "layouts/flash"), status: :unprocessable_entity
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
