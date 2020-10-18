class Food < ApplicationRecord
  belongs_to  :recipe

  validates   :name, present: true, length: {maximum: 20}
end
