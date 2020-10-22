class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :withdrawal, :unsubscribe]

  def index
    @users = User.where(is_deleted: "有効")

    if params[:search]
      @users = @users.where("family_name LIKE ?", "%#{params[:search]}%").page(params[:page]).per(10)

      if params[:search].present?
        @title = "検索結果：#{params[:search]}"
      else
        @title = "検索結果がありません"
      end

    elsif params[:followed]
      @users = current_user.followed_user.page(params[:page]).per(10)

      if current_user.followed_user.present?
        @title = "フォロー"
      else
        @title = "フォローユーザーがいません"
      end

    elsif params[:follower]
      @users = current_user.follower_user.page(params[:page]).per(10)

      if current_user.follower_user.present?
        @title = "フォロワー"
      else
        @title = "フォロワーがいません"
      end

    else
      @title = "ALL"
      @users = @users.page(params[:page]).per(10)
    end
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

    if @user.update(user_params)
      flash[:success] = "編集を保存しました"
      redirect_to user_path(current_user.id)
    else
      render "edit"
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
