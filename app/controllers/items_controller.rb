class ItemsController < ApplicationController
  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id

    if @item.save
      redirect_back fallback_location: user_path(current_user.id)
    else
      redirect_back fallback_location: user_path(current_user.id), notice: "保存に失敗しました"
    end
  end

  def destroy
    @item = Item.find(params[:id])

    if @item.user == current_user
      @item.destroy
      redirect_back fallback_location: user_path(current_user.id)
    else
      redirect_back fallback_location: user_path(current_user.id), notice: "他のユーザーの投稿は削除できません"
    end
  end

  private
  def item_params
    params.require(:item).permit(:name, :status)
  end
end
