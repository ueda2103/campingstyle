class RecipesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    if params[:search].present?
      @recipes = Recipe.where("title LIKE ?", "%#{params[:search]}%").where(status: "公開").order(id: "DESC").page(params[:page]).per(9)

      if @recipes.present?
        @title = "検索結果：#{params[:search]}"
      else
        @title = "ALL"
        redirect_to recipes_path, notice: "検索結果がありません"
      end

    elsif params[:tag_name]
      @recipes = Recipe.where(status: "公開").tagged_with("#{params[:tag_name]}").order(id: "DESC").page(params[:page]).per(9)
      @title = "#{params[:tag_name]}"

    else
      @recipes = Recipe.where(status: "公開").order(id: "DESC").page(params[:page]).per(9)
      @title = "ALL"
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
    @footprint = @recipe.footprint + 1
    @recipe.update(footprint: @footprint)
    @foods = Food.where(recipe_id: @recipe.id)
    @flows = Flow.where(recipe_id: @recipe.id)
    @comments = Comment.where(recipe_id: @recipe.id)
    @favorite = Favorite.find_by(user_id: current_user.id, recipe_id: params[:id])
    @bookmark = Bookmark.find_by(user_id: current_user.id, recipe_id: params[:id])
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id

    if @recipe.save
      redirect_to edit_recipe_path(@recipe.id), notice: "フォーマットが作成されました"
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
        redirect_to recipe_path(@recipe.id), notice: "保存しました"
      else
        @foods = Food.where(recipe_id: @recipe.id)
        @flows = Flow.where(recipe_id: @recipe.id)
        render "edit"
      end
    else
      redirect_back fallback_location: edit_recipe_path(@recipe.id), error: "材料・手順がありません"
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])

    if @recipe.destroy
      redirect_to recipe_path(@recipe.id), notice: "削除しました"
    else
      redirect_to new_recipe_path(@recipe.id), notice: "削除に失敗しました"
    end
  end

  private
  def recipe_params
    params.require(:recipe).permit({recipe_images: []}, :title, :body, :status, :tag_list)
  end
end
