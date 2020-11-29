module ApplicationHelper
  # 対象となるレコードがPostかRecipeかを判別（favoriteとbookmarkにて使用）
  def base_type(base)
    if base.respond_to? :status
      "recipe"
    else
      "post"
    end
  end
end
