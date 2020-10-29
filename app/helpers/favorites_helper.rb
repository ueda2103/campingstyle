module FavoritesHelper
  # 対象となるレコードがPostかRecipeかを判別
  def favorite_base_type(favorite_base)
    if favorite_base.respond_to? :status
      favorite_base_type = "recipe"
    else
      favorite_base_type = "post"
    end
  end
end
