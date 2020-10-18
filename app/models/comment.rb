class Comment < ApplicationRecord
  belongs_to  :user
  belongs_to  :post,    optional: true
  belongs_to  :recipe,  optional: true

  validates   :body,    presence: true, length: {maximum: 50}
end
