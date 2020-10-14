class RecipesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    if params[:search].present?
      @recipes = Recipe.where("title LIKE ?", "%#{params[:search]}%").order(id: "DESC").page(params[:page]).per(9)

      if @recipes.present?
        @title = "検索結果：#{params[:search]}"
      else
        @title = "ALL"
        redirect_to recipes_path, notice: "検索結果がありません"
      end

    else
      @recipes = Recipe.all.order(id: "DESC").page(params[:page]).per(9)
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
      redirect_to new_recipe_path, notice: "フォーマットの作成に失敗しました"
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
    @foods = Food.where(recipe_id: @recipe.id)
    @flows = Flow.where(recipe_id: @recipe.id)
  end

  def update
    @recipe = Recipe.find(params[:id])
    @recipe.status = "作成完了"

    if @recipe.update(recipe_params)
      redirect_to recipe_path(@recipe.id), notice: "保存されました"
    else
      redirect_to new_recipe_path(@recipe.id), notice: "保存に失敗しました"
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
    params.require(:recipe).permit({recipe_images: []}, :title, :body)
  end
end
