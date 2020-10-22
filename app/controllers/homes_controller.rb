class HomesController < ApplicationController

  def top
    today = Time.current.at_end_of_day
    from = (today - 6.day).at_beginning_of_day
    @posts = Post.where(created_at: from...today).order(footprint: "DESC").first(3)
    @recipes = Recipe.order(footprint: "DESC").first(3)

    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
