class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :withdrawal, :unsubscribe]
  before_action :check_guest, only: [:update, :unsubscribe]

  def index
    @users = User.where(is_deleted: "有効")

    if params[:search]
      
      if params[:search].present?
        @title = "検索結果：#{params[:search]}"
        @users = @users.where("family_name LIKE ?", "%#{params[:search]}%")
      else
        @title = "検索結果がありません"
      end

    elsif params[:followed]
      @users = current_user.followed_user

      if current_user.followed_user.present?
        @title = "フォロー"
      else
        @title = "フォローユーザーがいません"
      end

    elsif params[:follower]
      @users = current_user.follower_user

      if current_user.follower_user.present?
        @title = "フォロワー"
      else
        @title = "フォロワーがいません"
      end

    else
      @title = "ALL"
    end

    @users = @users.order(id: "DESC").page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])

    if @user.is_deleted == "退会済"
      flash[:error] = "対象のユーザーは退会済です"
      redirect_to users_path
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
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(current_user.id)
    @user.user_image = user_params[:user_image]
    result = false

    if user_params[:user_image].present?
      result = Vision.get_image_data(@user.user_image.url)
    else
      result = true
    end

    if result.blank?
      flash[:error] = "画像が不適切です"
      render "edit"
      return
    end

    if @user.update(user_params)
      flash[:success] = "編集を保存しました"
      redirect_to user_path(current_user.id)
    else
      flash[:error] = "保存に失敗しました"
      render "edit"
    end
  end

  def withdrawal
  end

  def unsubscribe
    @user = User.find(current_user.id)
    @user.update(is_deleted: true)
    reset_session
    redirect_to new_user_session_path
  end

  private
  def user_params
    params.require(:user).permit(:user_image, :family_name, :given_name, :family_name_kana,
     :given_name_kana, :email, :postal_code, :prefecture_code, :city, :street, :building, :telephone_number)
  end

  def check_user
    item = Item.find(params[:id])
    user = User.find(item.user_id)
    redirect_back fallback_location: user_path(current_uer.id) unless user == current_user
  end
end
