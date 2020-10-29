module BookmarksHelper
  # 対象となるレコードがPostかRecipeかを判別
  def bookmark_base_type(bookmark_base)
    if bookmark_base.respond_to? :status
      bookmark_base_type = "recipe"
    else
      bookmark_base_type = "post"
    end
  end
end
