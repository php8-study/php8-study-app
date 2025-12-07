# frozen_string_literal: true

class Admin::CategoriesController < ::AdminController
  before_action :set_category, only: [:edit, :update, :destroy, :render_row]
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
      render partial: "admin/categories/category", locals: { category: @category }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      flash.now[:notice] = "カテゴリー「#{ @category.name }」を削除しました"
      render turbo_stream: [
        turbo_stream.remove(@category),
        turbo_stream.update("flash", partial: "layouts/flash")
      ]
    else
      flash.now[:alert] = "削除できません：紐付く問題が存在します"
      render turbo_stream: turbo_stream.update("flash", partial: "layouts/flash")
    end
  end

  def edit
  end

  def render_row
    render partial: "admin/categories/category", locals: { category: @category }
  end


  private
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :chapter_number, :weight)
    end
end
