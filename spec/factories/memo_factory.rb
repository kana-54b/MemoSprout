FactoryBot.define do
  factory :memo do
    association :user # 関連するユーザーを自動的に作成

    # emotionをランダムに生成
    emotion do
      emotion_options = {
        "happy" => [ "嬉しかったこと・いいね" ],
        "angry" => [ "怒ったこと・イラッとしたこと" ],
        "sad" => [ "悲しかったこと・寂しかったこと" ],
        "funny" => [ "楽しかったこと・面白かったこと" ],
        "other" => [ "その他" ]
      }
      selected_emotion = emotion_options.keys.sample # ランダムに感情を選択
      { selected_emotion => emotion_options[selected_emotion] }.to_json
    end

    date { Faker::Date.backward(days: 14) } # 過去14日間からランダムな日付を生成

    memo_content do
      {
        what: "テスト メモ内容",
        why: "テスト なぜ",
        why_more: "テスト なぜの深堀り",
        how: "テスト どのように",
        summary: "テスト まとめ"
      }.to_json
    end
  end
end
