module ApplicationHelper
  # 対象となるレコードがPostかRecipeかを判別（favoriteとbookmarkにて使用）
  def base_type(base)
    if base.respond_to? :status
      base_type = "recipe"
    else
      base_type = "post"
    end
  end
end
