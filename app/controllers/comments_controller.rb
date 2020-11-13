class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [:destroy]

  def create
    @comment = Comment.create(comment_params)

    # Postにコメントする場合の処理
    if @comment.post_id.present?
      @comments = Comment.where(post_id: @comment.post_id)
    
    # Recipeにコメントする場合の処理
    else
      @comments = Comment.where(recipe_id: @comment.recipe_id)
    end
  end

  def destroy
    @comment = Comment.find(params[:id])

    # Postのコメントを削除する場合の処理
    if @comment.post_id.present?
      @comments = Comment.where(post_id: @comment.post_id)
      @comment.destroy

    # Recipeのコメントを削除する場合の処理
    else
      @comments = Comment.where(recipe_id: @comment.recipe_id)
      @comment.destroy
    end
  end

  private
  def comment_params
    params.permit(:user_id, :post_id, :recipe_id, :body)
  end

  def check_user
    comment = Comment.find(params[:id])
    user = User.find(comment.user_id)
    redirect_back fallback_location: post_path(comment.post_id) unless user == current_user
  end
end
