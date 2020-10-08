class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  mount_uploader :user_image, UserImageUploader

  validates :family_name, :given_name, :family_name_kana, :given_name_kana, :postal_code, :prefecture_code, :city, :street, :building, :telephone_number, :email, :encrypted_password, presence: true

  has_many  :posts
  has_many  :comments
  has_many  :bookmarks
  has_many  :follower, class_name: "Relationship", source: "follower_id", dependent: :destroy
  has_many  :followed, class_name: "Relationship", source: "followed_id", dependent: :destroy
  has_many  :following_user,  through: :follower, source: :followed
  has_many  :follower_user,   through: :followed, source: :follower

  include JpPrefecture
  jp_prefecture :prefecture_code

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end
end
