module MemosHelper
  def emotion_options
    [
      [ "嬉しかったこと・いいね", "happy" ],
      [ "怒ったこと・イラッとしたこと", "angry" ],
      [ "悲しかったこと・寂しかったこと", "sad" ],
      [ "楽しかったこと・面白かったこと", "funny" ],
      [ "その他", "other" ]
    ]
  end

  def emotion_label(emotion_key) # 確認ページ：選択した感情のラベルを返す
    emotion_options.to_h.invert[emotion_key]
  end

  def memo_example # 使い方・書き方例モーダル：メモの例
    {
      what: "おともだちと遊んだこと",
      why: "楽しかったから",
      why_more: "おままごとをした",
      how: "「おままごとしよ」って言った",
      summary: "おともだちとおままごとをしたのが嬉しかった。\n自分が「遊ぼう」って言ったから遊べた。\nまた「遊ぼう」って言う\n\n（5歳　女の子の例）"
    }.to_json
  end
end
