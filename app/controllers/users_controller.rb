class UsersController < ApplicationController
  def index
    @users = User.where(is_deleted: "有効")
  end

  def show
    @user = User.find(params[:id])

    if @user.is_deleted == "退会済"
      redirect_to users_path, notice: "退会済のユーザーです"
    end
    
    if @user == current_user
      @posts_bookmark = current_user.bookmark_post
      @recipes_bookmark = current_user.bookmark_recipe
      @item = Item.new
      @items = current_user.items
    else
      @posts = Post.where(user_id: params[:id])
      @recipes = Post.where(user_id: params[:id])
    end
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
