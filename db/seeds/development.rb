User.create!([
  { email: "b@b", password: "pass", password_confirmation: "pass", first_name: "やまだ", last_name: "はなこ" },
  { email: "c@c", password: "pass", password_confirmation: "pass", first_name: "たけだ", last_name: "じろう" },
  { email: "d@d", password: "pass", password_confirmation: "pass", first_name: "さとう", last_name: "たろう" }
])

Memo.create!([
  { emotion: "happy",
  memo_content: { "what" => "いいことの内容", "why" => "なぜの内容", "why_more" => "なぜの掘り下げ", "how" => "どうやって？", "summary" => "まとめ〜" },
  user_id: 1 },
  { emotion: "angry",
  memo_content: { "what" => "悪いことの内容", "why" => "なぜの内容", "why_more" => "なぜの掘り下げ", "how" => "どうやって？", "summary" => "まとめ〜" },
  user_id: 1 },
  { emotion: "happy",
  memo_content: { "what" => "いいことの内容", "why" => "なぜの内容", "why_more" => "なぜの掘り下げ", "how" => "どうやって？", "summary" => "まとめ〜" },
  user_id: 2 },
  { emotion: "angry",
  memo_content: { "what" => "悪いことの内容", "why" => "なぜの内容", "why_more" => "なぜの掘り下げ", "how" => "どうやって？", "summary" => "まとめ〜" },
  user_id: 2 },
  { emotion: "happy",
  memo_content: { "what" => "いいことの内容", "why" => "なぜの内容", "why_more" => "なぜの掘り下げ", "how" => "どうやって？", "summary" => "まとめ〜" },
  user_id: 3 },
  { emotion: "angry",
  memo_content: { "what" => "悪いことの内容", "why" => "なぜの内容", "why_more" => "なぜの掘り下げ", "how" => "どうやって？", "summary" => "まとめ〜" },
  user_id: 3 }
])
