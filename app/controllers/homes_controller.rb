class HomesController < ApplicationController

  def top
    today = Time.current.at_end_of_day
    from = (today - 6.day).at_beginning_of_day
    @posts = Post.where(created_at: from...today)
    @recipes = Recipe.order(footprint: "DESC").first(3)

    # 一週間の投稿が3件未満の場合
    if @posts.count < 3
      @posts = Post.all
    end
    
    @posts = @posts.order(footprint: "DESC").first(3)

    # ユーザーがログインしていない場合の処理
    redirect_to new_user_session_path unless user_signed_in?
  end
end
