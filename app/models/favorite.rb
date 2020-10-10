class Favorite < ApplicationRecord
  belongs_to  :user
  belongs_to  :post,    optional: true
  belongs_to  :recipe,  optional: true
end
