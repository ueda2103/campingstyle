class Item < ApplicationRecord
  belongs_to  :user

  validates   :name,    presence: true, length: {maximum: 20}
  validates   :status,  presence: true

  enum status: {
    "未所持": 0,
    "所持済": 1,
    "要購入": 2
  }
end
