class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [:destroy]

  def create
    @favorite = Favorite.new
    @favorite.user_id = current_user.id
    if params[:post_id].present?
      @favorite.post_id = params[:post_id]
      @favorite.save
      redirect_back fallback_location: posts_path
    else
      @favorite.recipe_id = params[:recipe_id]
      @favorite.save
      redirect_back fallback_location: recipes_path
    end
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    if @favorite.post_id.nil?
      @favorite.destroy
      redirect_back fallback_location: recipes_path
    else
      @favorite.destroy
      redirect_back fallback_location: posts_path
    end
  end

  private
  def check_user
    favorite = Favorite.find(params[:id])
    user = User.find(favorite.user_id)
    redirect_back fallback_location: user_path(current_uer.id) unless user == current_user
  end
end
