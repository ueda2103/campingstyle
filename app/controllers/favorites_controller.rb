class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @favorite = Favorite.new
    @favorite.user_id = current_user.id
    if params[:post_id].present?
      @favorite.post_id = params[:post_id]
    else
      @favorite.recipe_id = params[:recipe_id]
    end
    @favorite.save
    redirect_back fallback_location: posts_path
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
    redirect_back fallback_location: posts_path
  end
end
