class RecipesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @recipes = Recipe.where(status: "公開")

    if params[:search].present?
      @recipes = @recipes.where("title LIKE ?", "%#{params[:search]}%").order(id: "DESC").page(params[:page]).per(9)

      if @recipes.present?
        @title = "検索結果：#{params[:search]}"
      else
        @title = "検索結果がありません"
        redirect_to recipes_path
      end
    elsif params[:tag_name]
      @recipes = @recipes.tagged_with("#{params[:tag_name]}").order(id: "DESC").page(params[:page]).per(9)
      @title = "#{params[:tag_name]}"
    else
      @recipes = @recipes.order(id: "DESC").page(params[:page]).per(9)
      @title = "ALL"
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
    if @recipe.status == "公開" || @recipe.user_id == current_user.id
      @footprint = @recipe.footprint + 1
      @recipe.update(footprint: @footprint)
      @foods = Food.where(recipe_id: @recipe.id)
      @flows = Flow.where(recipe_id: @recipe.id)
      @comments = Comment.where(recipe_id: @recipe.id)
    elsif @recipe.status == "非公開"
      flash[:error] = "非公開のページです"
      redirect_to recipes_path
    end
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id

    if @recipe.save
      flash[:success] = "フォーマットが作成されました"
      redirect_to edit_recipe_path(@recipe.id)
    else
      render "new"
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
    @foods = Food.where(recipe_id: @recipe.id)
    @flows = Flow.where(recipe_id: @recipe.id)
  end

  def update
    @recipe = Recipe.find(params[:id])

    if @recipe.flows.present? && @recipe.foods.present?
      
      if @recipe.update(recipe_params)
        @recipe.update(status: "公開")
        flash[:success] = "保存しました"
        redirect_to recipe_path(@recipe.id)
      else
        @foods = Food.where(recipe_id: @recipe.id)
        @flows = Flow.where(recipe_id: @recipe.id)
        render "edit"
      end
    else
      flash[:error] = "材料・手順がありません"
      redirect_back fallback_location: edit_recipe_path(@recipe.id)
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])

    if @recipe.destroy
      flash[:success] = "削除しました"
      redirect_to recipe_path(@recipe.id)
    else
      flash[:error] = "削除に失敗しました"
      redirect_to new_recipe_path(@recipe.id)
    end
  end

  private
  def recipe_params
    params.require(:recipe).permit({recipe_images: []}, :title, :body, :status, :tag_list)
  end
end
