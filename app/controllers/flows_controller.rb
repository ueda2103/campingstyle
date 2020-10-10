class FlowsController < ApplicationController
  before_action :authenticate_user!

  def create
    @flow = Flow.create(flow_params)
    redirect_back fallback_location: edit_recipe_path(@flow.recipe_id)
  end

  def destroy
    @flow = Flow.find(params[:id])
    @flow.destroy
    redirect_back fallback_location: edit_recipe_path(@flow.recipe_id)
  end

  private
  def flow_params
    params.permit(:recipe_id, :body)
  end
end
