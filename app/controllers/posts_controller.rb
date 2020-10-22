class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @tags = Post.tag_counts
    
    if params[:search]
      @posts = Post.where("title LIKE ?", "%#{params[:search]}%").order(id: "DESC").page(params[:page]).per(8)

      if params[:search].present?
        @title = "検索結果：#{params[:search]}"
      else
        @title = "検索結果がありません"
      end

    elsif params[:tag_name]
      @posts = Post.tagged_with("#{params[:tag_name]}").page(params[:page]).per(8)
      @title = "検索結果：#{params[:tag_name]}"
      
    elsif params[:bookmarks]
      @posts = current_user.bookmark_post.order(id: "DESC").page(params[:page]).per(8)

      if current_user.bookmark_post.present?
        @title = "ブックマーク"
      else
        @title = "ブックマークがありません"
      end

    else
      @posts = Post.all.order(id: "DESC").page(params[:page]).per(8)
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
      flash[:success] = "投稿を保存しました"
      redirect_to post_path(@post.id)
    else
      render "new"
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    
    if @post.update(post_params)
      flash[:success] = "編集を保存しました"
      redirect_to post_path(@post.id)
    else
      render "edit"
    end
  end

  def destroy
    @post = Post.find(params[:id])

    if @post.user == current_user
      @post.destroy
      flash[:success] = "投稿を削除しました"
      redirect_to posts_path
    else
      flash[:error] = "他のユーザーの投稿は削除できません"
      redirect_back fallback_location: post_path(@post.id)
    end
  end

  private
  def post_params
    params.require(:post).permit({post_images: []}, :title, :body, :tag_list)
  end
end
