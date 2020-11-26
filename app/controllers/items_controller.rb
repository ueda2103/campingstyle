class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [:update, :destroy]

  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id
    @items = current_user.items
    @item.save
  end

  def update
    @item = Item.find(params[:id])
    @items = current_user.items
    @item.change_status
  end

  def destroy
    @item = Item.find(params[:id])
    @items = current_user.items
    @item.destroy
  end

  private

  def item_params
    params.require(:item).permit(:name, :status)
  end

  def check_user
    item = Item.find(params[:id])
    user = User.find(item.user_id)
    redirect_back fallback_location: user_path(current_uer.id) unless user == current_user
  end
end
