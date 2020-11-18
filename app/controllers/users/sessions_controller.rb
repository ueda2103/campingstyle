# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :reject_user, only: [:create]

  # GET /resource/sign_in
  def new
    today = Time.current.at_end_of_day
    from = (today - 6.day).at_beginning_of_day
    @posts = Post.where(created_at: from...today).order(footprint: "DESC").first(3)
    @recipes = Recipe.order(footprint: "DESC").first(3)
    
    # 一週間の投稿が3件未満の場合
    if @posts.count < 3
      @posts = Post.all
    end
    
    @posts = @posts.order(footprint: "DESC").first(3)
    super
  end

  # POST /resource/sign_in
  def create
    flash[:success] = "ログインしました"
    super
  end

  def create_guest
    user = User.guest
    sign_in user
    redirect_to root_path, success: "ゲストログインしました"
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  def reject_user
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user
      if @user.valid_password?(params[:user][:password]) && @user.active_for_authentication? == false
        redirect_to new_user_session_path
      end
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
