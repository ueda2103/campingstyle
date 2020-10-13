class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  mount_uploader :user_image, UserImageUploader

  validates :family_name, :given_name, :family_name_kana, :given_name_kana, :postal_code, :prefecture_code, :city, :street, :building, :telephone_number, :email, :encrypted_password, presence: true
  validates :telephone_number, :email, :encrypted_password, uniqueness: true

  has_many  :posts,     dependent: :destroy
  has_many  :recipes,   dependent: :destroy
  has_many  :comments,  dependent: :destroy
  has_many  :items,     dependent: :destroy
  has_many  :bookmarks, dependent: :destroy
  has_many  :bookmark_post,   through: :bookmarks, source: :post
  has_many  :bookmark_recipe, through: :bookmarks, source: :recipe
  has_many  :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many  :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many  :followed_user,   through: :followed, source: :follower
  has_many  :follower_user,   through: :follower, source: :followed

  def follower_by?(user)
    follower.where(followed_id: user.id).exists?
  end

  def follower_by(user)
    follower.find_by(followed_id: user.id)
  end

  include JpPrefecture
  jp_prefecture :prefecture_code

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end


  enum is_deleted: {"退会済": true, "有効": false}

  def active_for_authentication?
    super && self.is_deleted == "有効"
  end
end
