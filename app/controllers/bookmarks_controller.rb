class BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [:destroy]

  def create
    if params[:post_id].present?
      @post_recipe = Post.find(params[:post_id])
      @bookmark = Bookmark.new(user_id: current_user.id, post_id: @post_recipe.id)
    else
      @post_recipe = Recipe.find(params[:recipe_id])
      @bookmark = Bookmark.new(user_id: current_user.id, recipe_id: @post_recipe.id)
    end
    @bookmark.save
  end

  def destroy
    if params[:post_id].present?
      @post_recipe = Post.find(params[:post_id])
      @bookmark = Bookmark.find_by(user_id: current_user.id, post_id: @post_recipe.id)
    else
      @post_recipe = Recipe.find(params[:recipe_id])
      @bookmark = Bookmark.find_by(user_id: current_user.id, recipe_id: @post_recipe.id)
    end
    @bookmark.destroy
  end

  private
  def check_user
    bookmark = Bookmark.find(params[:id])
    user = User.find(bookmark.user_id)
    redirect_back fallback_location: user_path(current_uer.id) unless user == current_user
  end
end
