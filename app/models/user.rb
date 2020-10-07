class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  mount_uploader :user_image, UserImageUploader

  validates :family_name, :given_name, :family_name_kana, :given_name_kana, :postal_code, :prefecture_code, :city, :street, :building, :telephone_number, :email, :encrypted_password, presence: true

  has_many :comments
  has_many :posts

  include JpPrefecture
  jp_prefecture :prefecture_code

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end
end
