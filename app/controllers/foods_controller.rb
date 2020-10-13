class FoodsController < ApplicationController
  before_action :authenticate_user!

  def create
    @food = Food.create(food_params)
    redirect_back fallback_location: edit_recipe_path(@food.recipe_id)
  end

  def destroy
    @food = Food.find(params[:id])
    @food.destroy
    redirect_back fallback_location: edit_recipe_path(@food.recipe_id)
  end

  private
  def food_params
    params.permit(:recipe_id, :name)
  end
end
