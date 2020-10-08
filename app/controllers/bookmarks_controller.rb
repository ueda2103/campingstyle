class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    @bookmark = Bookmark.new
    @bookmark.user_id = current_user.id
    if params[:post_id].present?
      @bookmark.post_id = params[:post_id]
    else
      @bookmark.recipe_id = params[:recipe_id]
    end
    @bookmark.save
    redirect_back fallback_location: posts_path
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy
    redirect_back fallback_location: posts_path
  end
end
