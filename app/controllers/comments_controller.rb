class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [:destroy]

  def create
    @comment = Comment.create(comment_params)
    redirect_back fallback_location: post_path(@comment.post_id)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_back fallback_location: post_path(@comment.post_id)
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
