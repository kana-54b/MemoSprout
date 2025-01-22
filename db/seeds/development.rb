# User.create!([
#   { email: "a@a", password: "pass", password_confirmation: "pass", first_name: "たなか", last_name: "きのこ" },
#   { email: "b@b", password: "pass", password_confirmation: "pass", first_name: "やまだ", last_name: "はなこ" },
#   { email: "c@c", password: "pass", password_confirmation: "pass", first_name: "たけだ", last_name: "じろう" },
#   { email: "d@d", password: "pass", password_confirmation: "pass", first_name: "さとう", last_name: "たろう" }
# ])

# faker data
10.times do |n|
  Memo.create!(
    user_id: 1,
    date: "2024-01-01",
    emotion: "funny",
    memo_content: {
      "what" => "テスト#{ n + 1 }",
      "why" => "なぜの内容",
      "why_more" => "なぜの掘り下げ",
      "how" => "どうやって？",
      "summary" => "#{ Faker::Lorem.paragraph(sentence_count: 2) } (#{ Faker::Lorem.sentence(word_count: 1) })"
    }
  )
end
