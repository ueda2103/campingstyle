class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [:destroy]

  def create
    # Postにいいねする場合の処理
    if params[:favorite_base_type] == "post"
      @favorite_base = Post.find(params[:favorite_base_id])
      @favorite = Favorite.new(user_id: current_user.id, post_id: @favorite_base.id)
    
    # Recipeにいいねする場合の処理
    else
      @favorite_base = Recipe.find(params[:favorite_base_id])
      @favorite = Favorite.new(user_id: current_user.id, recipe_id: @favorite_base.id)
    end

    @favorite.save
  end

  def destroy
    # Postのいいねを削除する場合の処理
    if params[:favorite_base_type] == "post"
      @favorite_base = Post.find(params[:favorite_base_id])
      @favorite = @favorite_base.favorited_by(current_user)

    # Recipeのいいねを削除する場合の処理
    else
      @favorite_base = Recipe.find(params[:favorite_base_id])
      @favorite = @favorite_base.favorited_by(current_user)
    end

    @favorite.destroy
  end

  private
  # いいね削除実行ユーザーが対象のいいね作成ユーザーと同一であることの確認
  def check_user
    favorite = Favorite.find(params[:id])
    user = User.find(favorite.user_id)
    redirect_back fallback_location: user_path(current_uer.id) unless user == current_user
  end
end
