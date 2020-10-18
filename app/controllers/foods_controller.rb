class FoodsController < ApplicationController
  before_action :authenticate_user!

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
end
