class ItemsController < ApplicationController
  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id
    @items = current_user.items
    @item.save
  end

  def update
    @item = Item.find(params[:id])
    @items = current_user.items

    if @item.status == "未所持"
      @item.update(status: "所持済")
    elsif @item.status == "所持済"
      @item.update(status: "要購入")
    else
      @item.update(status: "未所持")
    end
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
end
