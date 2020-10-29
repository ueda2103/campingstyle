class Recipe < ApplicationRecord
  acts_as_taggable

  mount_uploaders :recipe_images, RecipeImagesUploader

  belongs_to  :user

  has_many    :favorites,       dependent: :destroy
  has_many    :comments,        dependent: :destroy
  has_many    :bookmarks,       dependent: :destroy
  has_many    :foods,           dependent: :destroy
  has_many    :flows,           dependent: :destroy
  has_many    :favorite_users,  through: :favorites, source: :user
  has_many    :bookmark_users,  through: :bookmarks, source: :user

  validates   :recipe_images, :footprint, :status, presence: true
  validates   :title, presence: true, length: {maximum: 20}
  validates   :body, presence:true, length: {maximum: 200}

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def favorited_by(user)
    favorites.find_by(user_id: user.id)
  end

  def bookmark_by?(user)
    bookmarks.where(user_id: user.id).exists?
  end

  def bookmark_by(user)
    bookmarks.find_by(user_id: user.id)
  end

  enum status: {"非公開":false, "公開":true}
end
