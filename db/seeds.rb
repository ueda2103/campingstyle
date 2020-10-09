# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  family_name: "高橋",
  given_name: "太郎",
  family_name_kana: "タカハシ",
  given_name_kana: "タロウ",
  postal_code: "1000002",
  prefecture_code: 13,
  city: "千代田区",
  street: "1番地",
  building: "インフラトップ 4F",
  telephone_number: "09011112222",
  email: "test@gmail.com",
  password: "password"
)

User.create!(
  family_name: "織田",
  given_name: "秀信",
  family_name_kana: "オダ",
  given_name_kana: "ヒデノブ",
  postal_code: "1000002",
  prefecture_code: 13,
  city: "千代田区",
  street: "1番地",
  building: "インフラトップ 4F",
  telephone_number: "09033332222",
  email: "test2@gmail.com",
  password: "password"
)

Post.create!(
  user_id: User.find(1).id,
  post_images: "1",
  title: "久々のソロキャンプ",
  body: "今日は楽しむぞ〜！",
  footprint: 3
)

Post.create!(
  user_id: User.find(1).id,
  post_images: "2",
  title: "車中泊",
  body: "雨だったー",
  footprint: 4
)

Recipe.create!(
  user_id: User.find(1).id,
  recipe_images: 1,
  title: "アヒージョ",
  body: "定番です！",
  footprint: 4
)

Comment.create!(
  user_id: User.find(2).id,
  post_id: Post.find(1).id,
  body: "こんにちは自分も行きたいです！"
)

Comment.create!(
  user_id: User.find(2).id,
  recipe_id: Recipe.find(1).id,
  body: "美味しそうですね！"
)

Food.create!(
  recipe_id: Recipe.find(1).id,
  name: "人参",
  quantity: "1本"
)

Flow.create!(
  recipe_id: Recipe.find(1).id,
  body: "適当な大きさに切ります"
)

Favorite.create!(
  user_id: User.find(2).id,
  post_id: Post.find(1).id
)

Bookmark.create!(
  user_id: User.find(2).id,
  recipe_id: Recipe.find(1).id
)

Relationship.create!(
  followed_id: User.find(2).id,
  follower_id: User.find(1).id
)

Item.create!(
  user_id: User.find(1).id,
  name: "ファイヤスターター",
  status: 0
)

Tag.create!(
  name: "ソロキャン"
)

TagEntry.create!(
  tag_id: Tag.find(1).id,
  recipe_id: Recipe.find(1).id
)

TagEntry.create!(
  tag_id: Tag.find(1).id,
  post_id: User.find(1).id
)