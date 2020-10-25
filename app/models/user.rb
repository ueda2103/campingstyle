class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable

  mount_uploader :user_image, UserImageUploader

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

  KATAKANA = /\A[\p{katakana}\u{30fc}]+\z/
  EMAIL = /\A\S+@\S+\.\S+\z/
  POST = /\A\d{7}\z/
  TELEPHONE = /\A\d{10,11}\z/

  validates :family_name, :given_name, :prefecture_code, :city, :street,:encrypted_password, presence: true
  validates :family_name_kana, :given_name_kana, presence: true, format: {with: KATAKANA}
  validates :postal_code, presence: true, format: {with: POST, allow_blank: true}
  validates :telephone_number, presence: true, format: {with: TELEPHONE, allow_blank: true}
  validates :email, presence: true, format: {with: EMAIL, allow_blank: true}, uniqueness: {case_sensitive: false}

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

  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.family_name = "Guest"
      user.given_name = "User"
      user.family_name_kana = "ゲスト"
      user.given_name_kana = "ユーザー"
      user.postal_code = 1000002
      user.prefecture_code = 13
      user.city = "千代田区"
      user.street = "1番地"
      user.telephone_number = "00000000000"
      user.password = SecureRandom.urlsafe_base64
    end
  end
end
