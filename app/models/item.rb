class Item < ApplicationRecord
  belongs_to  :user

  enum status: {
    "未所持": 0,
    "所持済": 1,
    "要購入": 2
  }
end
