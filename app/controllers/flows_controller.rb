class FlowsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [:destroy]

  def create
    @flow = Flow.create(flow_params)
    @flows = Flow.where(recipe_id: @flow.recipe_id)
  end

  def destroy
    @flow = Flow.find(params[:id])
    @flows = Flow.where(recipe_id: @flow.recipe_id)
    @flow.destroy
  end

  private

  def flow_params
    params.permit(:recipe_id, :body)
  end

  def check_user
    flow = Flow.find(params[:id])
    recipe = Recipe.find(flow.recipe_id)
    user = User.find(recipe.user_id)
    redirect_back fallback_location: user_path(current_uer.id) unless user == current_user
  end
end
