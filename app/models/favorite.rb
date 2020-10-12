class Favorite < ApplicationRecord
  belongs_to  :user
  belongs_to  :post,    optional: true
  belongs_to  :recipe,  optional: true

  def favorite_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def fovorite_by(user)
    favorites.where(user_id: user.id)
  end
end
