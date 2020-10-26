# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# シードデータ
# user
family_names = %w{
  佐藤:サトウ:sato
  鈴木:スズキ:suzuki
  高橋:タカハシ:takahasi
  田中:タナカ:tanaka
}

given_names = %w{
  太郎:タロウ:taro
  二郎:ジロウ:jiro
  三郎:サブロウ:saburo
  花子:ハナコ:hanako
  松子:マツコ:matuko
}

city_names = %w(青巻市 赤巻市 黄巻市)

20.times do |n|
  fn = family_names[n % 4].split(":")
  gn = given_names[n % 5].split(":")

  User.create!(
    family_name: fn[0],
    given_name: gn[0],
    family_name_kana: fn[1],
    given_name_kana: gn[1],
    postal_code: sprintf("%07d", rand(10000000)),
    prefecture_code: Random.rand(47),
    city: city_names.sample,
    street: "試験 1-2-3",
    building: "インフラトップ",
    telephone_number: sprintf("0900000%04d", n * 10 + n),
    email: "#{fn[2]}.#{gn[2]}@example.jp",
    password: "password",
  )
end

# post
post_titles_tags = %w{
  ソロキャンプ
  ファミリーキャンプ
  車中泊
  グランピング
  野営
  デイキャンプ
  オートキャンプ
  ツーリングキャンプ
  TeePee style
  Tree house style
}

post_sub_titles = %w{
  雨の
  久々の
  オシャレな
  ギリギリの
}

40.times do |n|
  i = Random.rand(20) + 1
  c = Random.rand(3) + 1
  tt = post_titles_tags[n % 10]
  st = post_sub_titles[n % 4]

  Post.create!(
    user_id: User.find(i).id,
    post_images: [open("db/fixtures/images/#{c}.jpg")],
    title: "#{st}#{tt}",
    body: "楽しむぞ",
    footprint: Random.rand(100)
  )
end

# recipe
recipe_titles_tags = %w{
  ナポリタン
  焼肉
  バーベキュー
  アヒージョ
  ホットドック
  焼き鳥
  ビーフストロガノフ
  ハンバーグ
  生春巻き
  ハムエッグ
}

recipe_sub_titles = %w{
  定番の
  美味しい
  オシャレな
  しょっぱい
}

40.times do |n|
  i = Random.rand(20) + 1
  c = Random.rand(3) + 1
  tt = recipe_titles_tags[n % 10]
  st = recipe_sub_titles[n % 4]

  Recipe.create!(
    user_id: User.find(i).id,
    recipe_images: [open("db/fixtures/images/#{c}.jpg")],
    title: "#{st}#{tt}",
    body: "楽しむぞ〜！",
    status: true,
    footprint: Random.rand(100)
  )
end

# コメント
80.times do |n|
  ui = Random.rand(20) + 1
  pi = Random.rand(40) + 1

  Comment.create!(
    user_id: User.find(ui).id,
    post_id: Post.find(pi).id,
    body: "こんにちは自分も行きたいです！"
  )
end

80.times do |n|
  ui = Random.rand(20) + 1
  ri = Random.rand(40) + 1

  Comment.create!(
    user_id: User.find(ui).id,
    recipe_id: Recipe.find(ri).id,
    body: "こんにちは美味しそうですね！"
  )
end

# 食材
foods = %w{
  人参
  玉ねぎ
  豚肉
  しめじ
  ベーコン
  卵
  ニンニク
  醤油
  塩
  胡椒
}

200.times do |n|
  ri = Random.rand(40) + 1
  fi = Random.rand(10)
  f = foods[fi]

  Food.create!(
    recipe_id: Recipe.find(ri).id,
    name: "#{f}"
  )
end

# 手順
flows = %w{
  細かく刻む
  ざく切りにする
  手でちぎる
  油をしく
  塩をふる
  胡椒をまぶす
  火にかける
  焦げ目がつくまで焼く
  油であげる
  煮る
}

200.times do |n|
  ri = Random.rand(40) + 1
  fi = Random.rand(10)
  f = flows[fi]

  Flow.create!(
    recipe_id: Recipe.find(ri).id,
    body: "#{f}"
  )
end

# いいね
40.times do |n|
  ui = (n % 20) + 1
  pi = (n % 40) + 1

  Favorite.create!(
    user_id: User.find(ui).id,
    post_id: Post.find(pi).id
  )
end

40.times do |n|
  ui = (n % 20) + 1
  ri = (n % 40) + 1

  Favorite.create!(
    user_id: User.find(ui).id,
    recipe_id: Recipe.find(ri).id
  )
end

# ブックマーク
40.times do |n|
  ui = (n % 20) + 1
  pi = (n % 40) + 1

  Bookmark.create!(
    user_id: User.find(ui).id,
    post_id: Post.find(pi).id
  )
end

40.times do |n|
  ui = (n % 20) + 1
  ri = (n % 40) + 1

  Bookmark.create!(
    user_id: User.find(ui).id,
    recipe_id: Recipe.find(ri).id
  )
end

# フォロー
20.times do |n|
  ui = (n % 20) + 1
  fi = 21 - ui

  Relationship.create!(
    followed_id: User.find(ui).id,
    follower_id: User.find(fi).id
  )
end

# アイテム
items = %w{
  ファイヤスターター
  焚き火台
  着火剤
  テント
  タープ
  ランタン
  豚肉
  オイルサーディン
  蟹味噌缶
  レモン
  ニンニク
  胡椒
  バター
  オリーブオイル
}

250.times do |n|
  ui = (n % 20) + 1
  ii = (n % 14)

  Item.create!(
    user_id: User.find(ui).id,
    name: "#{items[ii]}",
    status: Random.rand(3)
  )
end

# タグリスト
post_titles_tags.each do |tag| 
  tag_list = ActsAsTaggableOn::Tag.new
  tag_list.name = tag
  tag_list.save
end

recipe_titles_tags.each do |tag|
  tag_list = ActsAsTaggableOn::Tag.new
  tag_list.name = tag
  tag_list.save
end