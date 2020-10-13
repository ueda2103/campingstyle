class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :withdrawal, :unsubscribe]

  def index
    @users = User.where(is_deleted: "有効")
    if params[:search].present?
      @users = @users.where("family_name LIKE ?", "%#{params[:search]}%")
      if @users.present?
        @title = "検索結果：#{params[:search]}"
      else
        @title = "ALL"
        redirect_to users_path, notice: "検索結果がありません"
      end
    else
      @title = "ALL"
    end
  end

  def show
    @user = User.find(params[:id])

    if @user.is_deleted == "退会済"
      redirect_to users_path, notice: "退会済のユーザーです"
    end
    
    if @user == current_user
      @item = Item.new
      @items = current_user.items
    else
      redirect_to users_posts_path(params[:id])
    end
  end

  def posts
    @user = User.find(params[:id])
    @posts = Post.where(user_id: params[:id]).page(params[:page]).per(9)
  end
  
  def recipes
    @user = User.find(params[:id])
    @recipes = Recipe.where(user_id: params[:id]).page(params[:page]).per(9)
  end

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      redirect_to user_path(current_user.id), notice: "編集を保存しました"
    else
      redirect_back fallback_location: edit_user_path(current_user.id), notice: "保存に失敗しました"
    end
  end

  def withdrawal
  end

  def unsubscribe
    @user = User.find(current_user.id)
    @user.update(is_deleted: true)
    reset_session
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:user_image,:family_name, :given_name, :family_name_kana, :given_name_kana, :postal_code, :prefecture_code, :city, :street, :building, :telephone_number)
  end
end
