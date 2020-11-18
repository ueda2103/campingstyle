class RecipesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :check_user, only: [:edit, :update, :destroy]

  def index
    @recipes = Recipe.where(status: "公開")
    @tags = @recipes.tag_counts_on(:tags)

    if params[:search]
      
      if params[:search].present?
        @title = "検索結果：#{params[:search]}"
        @recipes = @recipes.where("title LIKE ?", "%#{params[:search]}%").order(id: "DESC").page(params[:page]).per(12)
      else
        @title = "検索結果がありません"
      end

    elsif params[:bookmarks]
      @recipes = current_user.bookmark_recipe

      if current_user.bookmark_recipe.present?
        @title = "ブックマーク"
      else
        @title = "ブックマークがありません"
      end

    elsif params[:tag_name]
      @recipes = @recipes.tagged_with("#{params[:tag_name]}")
      @title = "検索結果：#{params[:tag_name]}"
      
    else
      @title = "ALL"
    end

    @recipes = @recipes.order(id: "DESC").page(params[:page]).per(12)
  end

  def show
    @recipe = Recipe.find(params[:id])
    if @recipe.status == "公開" || @recipe.user_id == current_user.id
      @footprint = @recipe.footprint
      if user_signed_in?
        @footprint = @footprint + 1 unless @recipe.user_id == current_user.id
      end
      @recipe.update(footprint: @footprint)
      @foods = Food.where(recipe_id: @recipe.id)
      @flows = Flow.where(recipe_id: @recipe.id)
      @comments = Comment.where(recipe_id: @recipe.id)

      if @recipe.status == "非公開"
        flash[:error] = "非公開のページです"
      end
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
    result = false
    result = Vision.get_image_data(@recipe.recipe_images[0].url)

    if result.blank?
      flash[:error] = "画像が不適切です"
      render "new"
      return
    end

    if @recipe.save
      flash[:success] = "フォーマットが作成されました"
      redirect_to edit_recipe_path(@recipe.id)
    else
      flash[:error] = "保存に失敗しました"
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
    @recipe.recipe_images = recipe_params[:recipe_images]
    @foods = Food.where(recipe_id: @recipe.id)
    @flows = Flow.where(recipe_id: @recipe.id)
    result = false

    if recipe_params[:recipe_images].present?
      result = Vision.get_image_data(@recipe.recipe_images[0].url)
    else
      result = true
    end

    if result.blank?
      flash[:error] = "画像が不適切です"
      render "edit"
      return
    end

    if @recipe.flows.present? && @recipe.foods.present?
      
      if @recipe.update(recipe_params)
        @recipe.update(status: "公開")
        flash[:success] = "編集を保存しました"
        redirect_to recipe_path(@recipe.id)
      else
        flash[:error] = "保存に失敗しました"
        render "edit"
      end
      
    else
      if @recipe.update(status: "非公開")
        flash[:error] = "材料・手順がないため非公開で保存しました"
        redirect_to recipe_path(@recipe.id)
      else
        flash[:error] = "保存に失敗しました"
        render "edit"
      end
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])

    if @recipe.destroy
      flash[:success] = "削除しました"
      redirect_to recipes_path
    else
      flash[:error] = "削除に失敗しました"
      redirect_to recipe_path(@recipe.id)
    end
  end

  private
  def recipe_params
    params.require(:recipe).permit({recipe_images: []}, :title, :body, :status, :tag_list)
  end

  def check_user
    recipe = Recipe.find(params[:id])
    user = User.find(recipe.user_id)
    redirect_back fallback_location: user_path(current_user.id) unless user == current_user
  end
end
