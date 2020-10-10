class Recipe < ApplicationRecord
  mount_uploader  :recipe_images, RecipeImagesUploader

  belongs_to  :user

  has_many    :favorites,       dependent: :destroy
  has_many    :comments,        dependent: :destroy
  has_many    :bookmarks,       dependent: :destroy
  has_many    :foods,           dependent: :destroy
  has_many    :flows,           dependent: :destroy
  has_many    :favorite_users,  through: :favorites, source: :user
  has_many    :bookmark_users,  through: :bookmarks, source: :user
end
