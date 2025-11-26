# frozen_string_literal: true

class Admin::CategoriesController < ::ApplicationController
  before_action :set_category, only: [:edit, :update, :destroy, :render_row]
  def index
    @categories = Category.all.order(:chapter_number)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy

    respond_to do |format|
      format.html { redirect_to admin_categories_url, notice: "問題が削除されました。" }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@category) }
    end
  end

  def edit
    render :edit, layout: false
  end

  def update
    if @category.update(category_params)
      render partial: "admin/categories/category", locals: { category: @category }
    else
      render :edit, status: :unprocessable_entity
    end
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
