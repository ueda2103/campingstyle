class FlowsController < ApplicationController
  before_action :authenticate_user!

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
end
