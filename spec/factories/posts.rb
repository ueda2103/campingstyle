FactoryBot.define do
  factory :post do
    post_images { [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/demo.jpg", "image/jpeg")] }
    title { "キャンプ" }
    body { "楽しい" }
    tag_list { "オートキャンプ, ファミリーキャンプ" }
    footprint { 1 }
    user_id { 1 }
  end

  factory :comment_post, :class => "comment" do
    body { "こんにちは" }
    user_id { 1 }
    post_id { 1 }
  end
  
  factory :favorite_post, :class => "favorite" do
    user_id { 1 }
    post_id { 1 }
  end

  factory :bookmark_post, :class => "bookmark" do
    user_id { 1 }
    post_id { 1 }
  end
end