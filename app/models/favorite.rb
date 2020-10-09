class Favorite < ApplicationRecord
  belongs_to  :user,    optional: true
  belongs_to  :post,    optional: true
  belongs_to  :recipe,  optional: true
end
