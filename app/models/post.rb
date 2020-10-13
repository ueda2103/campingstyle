class Post < ApplicationRecord
  mount_uploaders :post_images, PostImagesUploader

  belongs_to  :user

  has_many    :favorites,       dependent: :destroy
  has_many    :comments,        dependent: :destroy
  has_many    :bookmarks,       dependent: :destroy
  has_many    :favorite_users,  through: :favorites, source: :user
  has_many    :bookmark_users,  through: :bookmarks, source: :user

  def post_favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def post_favorited_by(user)
    favorites.find_by(user_id: user.id)
  end

  def post_bookmark_by?(user)
    bookmarks.where(user_id: user.id).exists?
  end

  def post_bookmark_by(user)
    bookmarks.find_by(user_id: user.id)
  end
end
