class BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [:destroy]

  def create
    @bookmark = Bookmark.new
    @bookmark.user_id = current_user.id
    if params[:post_id].present?
      @bookmark.post_id = params[:post_id]
      @bookmark.save
      redirect_back fallback_location: posts_path
    else
      @bookmark.recipe_id = params[:recipe_id]
      @bookmark.save
      redirect_back fallback_location: recipes_path
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    if @bookmark.post_id.nil?
      @bookmark.destroy
      redirect_back fallback_location: recipes_path
    else
      @bookmark.destroy
      redirect_back fallback_location: posts_path
    end
  end

  private
  def check_user
    bookmark = Bookmark.find(params[:id])
    user = User.find(bookmark.user_id)
    redirect_back fallback_location: user_path(current_uer.id) unless user == current_user
  end
end
