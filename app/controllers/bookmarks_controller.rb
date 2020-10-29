class BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [:destroy]

  def create
    # Postをブックマークする場合の処理
    if params[:bookmark_base_type] == "post"
      @bookmark_base = Post.find(params[:bookmark_base_id])
      @bookmark = Bookmark.new(user_id: current_user.id, post_id: @bookmark_base.id)
    
    # Recipeをブックマークする場合の処理
    else
      @bookmark_base = Recipe.find(params[:bookmark_base_id])
      @bookmark = Bookmark.new(user_id: current_user.id, recipe_id: @bookmark_base.id)
    end

    @bookmark.save
  end

  def destroy
    # Postのブックマークを削除する場合の処理
    if params[:bookmark_base_type] == "post"
      @bookmark_base = Post.find(params[:bookmark_base_id])
      @bookmark = @bookmark_base.bookmark_by(current_user)

    # Recipeのブックマークを削除する場合の処理
    else
      @bookmark_base = Recipe.find(params[:bookmark_base_id])
      @bookmark = @bookmark_base.bookmark_by(current_user)
    end

    @bookmark.destroy
  end

  private
  # ブックマーク削除実行ユーザーが対象のブックマーク作成ユーザーと同一であることの確認
  def check_user
    bookmark = Bookmark.find(params[:id])
    user = User.find(bookmark.user_id)
    redirect_back fallback_location: user_path(current_uer.id) unless user == current_user
  end
end
