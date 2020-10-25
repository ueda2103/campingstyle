class FoodsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [:destroy]

  def create
    @food = Food.create(food_params)
    @foods = Food.where(recipe_id: @food.recipe_id)
  end
  
  def destroy
    @food = Food.find(params[:id])
    @foods = Food.where(recipe_id: @food.recipe_id)
    @food.destroy
  end

  private
  def food_params
    params.permit(:recipe_id, :name)
  end

  def check_user
    food = Food.find(params[:id])
    user = User.find(food.user_id)
    redirect_back fallback_location: user_path(current_uer.id) unless user == current_user
  end
end
