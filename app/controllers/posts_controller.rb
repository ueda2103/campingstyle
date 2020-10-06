class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.all
    @tags = Tag.all
  end

  def show
    @post = Post.find(params[:id])
    @post.footprint = @post.footprint + 1
  end

  def new
    
  end

  def create
    
  end

  def edit
    
  end

  def update
    
  end

  def destroy
    
  end

  private
  def post_params
    params.require(:post).permit(:post_images, :title, :body)
  end
end
