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
        @recipes = Recipe.where(status: "公開").order(id: "DESC").page(params[:page]).per(12)
      end

    elsif params[:bookmarks]
      @recipes = current_user.bookmark_recipe.order(id: "DESC").page(params[:page]).per(12)

      if current_user.bookmark_recipe.present?
        @title = "ブックマーク"
      else
        @title = "ブックマークがありません"
      end

    elsif params[:tag_name]
      @recipes = @recipes.tagged_with("#{params[:tag_name]}").order(id: "DESC").page(params[:page]).per(12)
      @title = "検索結果：#{params[:tag_name]}"
      
    else
      @recipes = @recipes.order(id: "DESC").page(params[:page]).per(12)
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

    if @recipe.flows.present? && @recipe.foods.present?
      
      if @recipe.update(recipe_params)
        @recipe.update(status: "公開")
        flash[:success] = "編集を保存しました"
        redirect_to recipe_path(@recipe.id)
      else
        @foods = Food.where(recipe_id: @recipe.id)
        @flows = Flow.where(recipe_id: @recipe.id)
        flash[:error] = "保存に失敗しました"
        render "edit"
      end
    else
      @recipe.update(status: "非公開")
      flash[:error] = "材料・手順がないため非公開で保存しました"
      redirect_to recipe_path(@recipe.id)
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
    redirect_back fallback_location: user_path(current_uer.id) unless user == current_user
  end
end
