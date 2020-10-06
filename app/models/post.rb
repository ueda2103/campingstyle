class Post < ApplicationRecord
  belongs_to  :user

  has_many    :favorites,       dependent: :destroy
  has_many    :favorite_users,  through: :favorites, source: :user
  has_many    :comments,        dependent: :destroy
end
