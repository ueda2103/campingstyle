class Flow < ApplicationRecord
  belongs_to  :recipe

  validates   :body, presence: true, length: { maximum: 50 }
end
