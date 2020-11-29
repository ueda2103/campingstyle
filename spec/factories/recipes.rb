FactoryBot.define do
  factory :recipe do
    recipe_images { [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/demo.jpg", "image/jpeg")] }
    title { "ご飯" }
    body { "楽しい" }
    tag_list { "メイン, オイルサーディン" }
    status { "非公開" }
    footprint { 1 }
    user_id { 1 }
  end

  factory :food do
    name { "オイルサーディン" }
    recipe_id { 1 }
  end
  
  factory :flow do
    body { "10分火にかける" }
    recipe_id { 1 }
  end

  factory :comment_recipe, :class => "comment" do
    body { "こんにちは" }
    user_id { 1 }
    recipe_id { 1 }
  end

  factory :favorite_recipe, :class => "favorite" do
    user_id { 1 }
    recipe_id { 1 }
  end

  factory :bookmark_recipe, :class => "bookmark" do
    user_id { 1 }
    recipe_id { 1 }
  end
end