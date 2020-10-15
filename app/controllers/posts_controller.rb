class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    if params[:search].present?
      @posts = Post.where("title LIKE ?", "%#{params[:search]}%").order(id: "DESC").page(params[:page]).per(9)

      if @posts.present?
        @title = "検索結果：#{params[:search]}"
      else
        @title = "ALL"
        redirect_to posts_path, notice: "検索結果がありません"
      end

    elsif params[:tag_name]
      @posts = Post.tagged_with("#{params[:tag_name]}").page(params[:page]).per(9)
      @title = "#{params[:tag_name]}"
      
    else
      @posts = Post.all.order(id: "DESC").page(params[:page]).per(9)
      @title = "ALL"
    end
  end

  def show
    @post = Post.find(params[:id])
    @footprint = @post.footprint + 1
    @post.update(footprint: @footprint)
    @comments = Comment.where(post_id: params[:id])
    @favorite = Favorite.find_by(user_id: current_user.id, post_id: params[:id])
    @bookmark = Bookmark.find_by(user_id: current_user.id, post_id: params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      redirect_to post_path(@post.id), notice: "投稿が保存されました"
    else
      redirect_back fallback_location: new_post_path, notice: "保存に失敗しました"
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    
    if @post.update(post_params)
      redirect_to post_path(@post.id), notice: "編集が保存されました"
    else
      redirect_back fallback_location: edit_post_path(@post.id), notice: "保存に失敗しました"
    end
  end

  def destroy
    @post = Post.find(params[:id])

    if @post.user == current_user
      @post.destroy
      redirect_to posts_path, notice: "正常に削除されました"
    else
      redirect_back fallback_location: post_path(@post.id), notice: "他のユーザーの投稿は削除できません"  
    end
  end

  private
  def post_params
    params.require(:post).permit({post_images: []}, :title, :body, :tag_list)
  end
end
