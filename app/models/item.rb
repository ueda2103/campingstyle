class Item < ApplicationRecord
  belongs_to  :user

  validates   :name,    presence: true, length: {maximum: 20}
  validates   :status,  presence: true

  enum status: {
    "未所持": 0,
    "所持済": 1,
    "要購入": 2
  }

  # 所持ステータスの変更
  def change_status
    case self.status
    when "未所持"
      self.update(status: "所持済")
    when "所持済"
      self.update(status: "要購入")
    when "要購入"
      self.update(status: "未所持")
    end
  end
end
