# frozen_string_literal: true

class Admin::CategoriesController < Admin::ApplicationController
  before_action :set_category, only: [:edit, :update, :destroy, :show]
  def index
    @categories = Category.order(:chapter_number)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: "カテゴリーを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      flash.now[:notice] = "カテゴリーを更新しました"
      render turbo_stream: [
        turbo_stream.replace(
          @category,
          Admin::Categories::List::Row::Component.new(
            category: @category,
            grid_cols: Admin::Categories::List::Component::GRID_COLS
          )
        ),
        turbo_stream.update("flash", Common::Flash::Component.new(flash: flash))
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      flash.now[:notice] = "カテゴリー「#{ @category.name }」を削除しました"
      render turbo_stream: [
        turbo_stream.remove(@category),
        turbo_stream.update("flash", Common::Flash::Component.new(flash: flash))
      ]
    else
      flash.now[:alert] = "削除できません：紐付く問題が存在します"
      render turbo_stream: turbo_stream.update("flash", Common::Flash::Component.new(flash: flash)),
      status: :unprocessable_entity
    end
  end

  def edit
  end

  def show
    render Admin::Categories::List::Row::Component.new(
      category: @category,
      grid_cols: Admin::Categories::List::Component::GRID_COLS
    )
  end


  private
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :chapter_number, :weight)
    end
end
