class Recipe < ApplicationRecord
  mount_uploaders :recipe_images, RecipeImagesUploader

  belongs_to  :user

  has_many    :favorites,       dependent: :destroy
  has_many    :comments,        dependent: :destroy
  has_many    :bookmarks,       dependent: :destroy
  has_many    :foods,           dependent: :destroy
  has_many    :flows,           dependent: :destroy
  has_many    :favorite_users,  through: :favorites, source: :user
  has_many    :bookmark_users,  through: :bookmarks, source: :user

  def recipe_favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def recipe_favorited_by(user)
    favorites.find_by(user_id: user.id)
  end

  def recipe_bookmark_by?(user)
    bookmarks.where(user_id: user.id).exists?
  end

  def recipe_bookmark_by(user)
    bookmarks.find_by(user_id: user.id)
  end
end
