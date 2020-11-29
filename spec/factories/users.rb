FactoryBot.define do
  factory :user do
    user_image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/demo.jpg", "image/jpeg") }
    family_name { "山田" }
    given_name { "太郎" }
    family_name_kana { "ヤマダ" }
    given_name_kana { "タロウ" }
    postal_code { "1000002" }
    prefecture_code { 13 }
    city { "千代田区皇居外苑" }
    street { "1番地" }
    building { "江戸城" }
    sequence(:telephone_number) { |n| sprintf("0900000%04d", n) }
    is_deleted { "有効" }
    sequence(:email) { |n| "test#{n}@gmail.com" }
    password { "password" }
  end

  factory :relationship do
    followed_id { 1 }
    follower_id { 2 }
  end
end