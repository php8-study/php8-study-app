# frozen_string_literal: true

class Admin::QuestionsController < Admin::ApplicationController
  before_action :set_question, only: [:edit, :update, :destroy]

  def index
    @questions = Question.preload(:category).active.order(created_at: :desc)
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
    if (@saved_question = @question.safe_update(question_params)) # 使用中であれば論理削除して新verを作成、そうでなければ更新するメソッド
      redirect_to edit_admin_question_path(@saved_question), notice: "問題を保存しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @question.safe_destroy!

    flash.now[:notice] = "問題を削除しました"
    render turbo_stream: [
      turbo_stream.remove(@question),
      turbo_stream.update("flash", Common::Flash::Component.new(flash: flash))
      ]
  end

  private
    def set_question
      @question = Question.active.find(params[:id])
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
