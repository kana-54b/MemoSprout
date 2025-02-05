module MemosHelper
  def emotion_options
    [
      [ "嬉しかったこと・いいね", "happy", "text-[#9d7abc]" ],
      [ "怒ったこと・イラッとしたこと", "angry", "text-[#D62828]" ],
      [ "悲しかったこと・寂しかったこと", "sad", "text-[#3D5F91]" ],
      [ "楽しかったこと・面白かったこと", "funny", "text-[#E6953D]" ],
      [ "その他", "other", "text-[#4F8D60]" ]
    ]
  end

  def emotion_label(emotion_key) # 確認ページ：選択した感情のラベルを返す
    option = emotion_options.find { |_, value, _| value == emotion_key }
    option ? option[0] : ""
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
