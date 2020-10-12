class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [:destroy]

  def create
    if params[:post_id].present?
      @post_recipe = Post.find(params[:post_id])
      @favorite = Favorite.new(user_id: current_user.id, post_id: @post_recipe.id)
    else
      @post_recipe = Recipe.find(params[:recipe_id])
      @favorite = Favorite.new(user_id: current_user.id, recipe_id: @post_recipe.id)
    end
    @favorite.save
  end

  def destroy
    if params[:post_id].present?
      @post_recipe = Post.find(params[:post_id])
      @favorite = Favorite.find_by(user_id: current_user.id, post_id: @post_recipe.id)
    else
      @post_recipe = Recipe.find(params[:recipe_id])
      @favorite = Favorite.find_by(user_id: current_user.id, recipe_id: @post_recipe.id)
    end
    @favorite.destroy
  end

  private
  def check_user
    favorite = Favorite.find(params[:id])
    user = User.find(favorite.user_id)
    redirect_back fallback_location: user_path(current_uer.id) unless user == current_user
  end
end
