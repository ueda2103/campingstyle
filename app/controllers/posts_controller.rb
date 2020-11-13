class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :check_user, only: [:edit, :update, :destroy]

  def index
    @posts = Post.all
    @tags = @posts.tag_counts_on(:tags)
    
    if params[:search]
      
      if params[:search].present?
        @title = "検索結果：#{params[:search]}"
        @posts = Post.where("title LIKE ?", "%#{params[:search]}%").order(id: "DESC").page(params[:page]).per(12)
      else
        @title = "検索結果がありません"
        @posts = @posts.order(id: "DESC").page(params[:page]).per(12)
      end

    elsif params[:tag_name]
      @posts = Post.tagged_with("#{params[:tag_name]}").page(params[:page]).per(12)
      @title = "検索結果：#{params[:tag_name]}"
      
    elsif params[:bookmarks]
      @posts = current_user.bookmark_post.order(id: "DESC").page(params[:page]).per(12)

      if current_user.bookmark_post.present?
        @title = "ブックマーク"
      else
        @title = "ブックマークがありません"
      end

    else
      @posts = Post.all.order(id: "DESC").page(params[:page]).per(12)
      @title = "ALL"
    end
  end

  def show
    @post = Post.find(params[:id])
    @footprint = @post.footprint + 1
    @post.update(footprint: @footprint)
    @comments = Comment.where(post_id: params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    result = false
    result = Vision.get_image_data(@post.post_images[0].url)

    if result.blank?
      flash[:error] = "画像が不適切です"
      render "new"
      return
    end

    if @post.save
      flash[:success] = "投稿を保存しました"
      redirect_to post_path(@post.id)
    else
      flash[:error] = "保存に失敗しました"
      render "new"
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.post_images = post_params[:post_images]
    result = false

    if post_params[:post_images].present?
      result = Vision.get_image_data(@post.post_images[0].url)
    else
      result = true
    end
    
    if result.blank?
      flash[:error] = "画像が不適切です"
      render "edit"
      return
    end

    if @post.update(post_params)
      flash[:success] = "編集を保存しました"
      redirect_to post_path(@post.id)
    else
      flash[:error] = "保存に失敗しました"
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

  def check_user
    post = Post.find(params[:id])
    user = User.find(post.user_id)
    redirect_back fallback_location: user_path(current_user.id) unless user == current_user
  end
end
