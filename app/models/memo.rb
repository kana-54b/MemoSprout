class Memo < ApplicationRecord
  belongs_to :user
  has_one :memo_favorite, dependent: :destroy

  validates :memo_content, presence: true
  validate :validate_memo_content

  def validate_memo_content
    # memo_contentがJSON形式であることを前提にデータを取得
    data = JSON.parse(memo_content) rescue {}

    if data["what"].blank? || data["why"].blank? || data["why_more"].blank? || data["how"].blank? || data["summary"].blank?
      errors.add(:base, :required_fields) # 「(*)は必須項目です」
    end
  end

  ### memo_contentデータの作成前にJSON形式に変換 ###
  def memo_content=(value)
    if value.is_a?(Hash)
      super(value.to_json)
    else
      super
    end
  end

  ### current_userがお気に入り登録しているかを確認 ###
  def favorited_by?(user)
    memo_favorite&.user_id == user.id
  end

  ### メモの連続記録 ###
  def self.streak_days(user)
    today = Date.today
    streak_count = 0 # 連続記録をカウントする
    previous_date = today + 1 # 初期値を明日に設定

    # メモの日付だけを取得。同じ日付は排除し、降順に並べる
    uniq_dates = user.memos.where("created_at <= ?", today.end_of_day)
                            .order(created_at: :desc)
                            .pluck(:created_at)
                            .map(&:to_date)
                            .uniq

    uniq_dates.each do |memo_date|
      if previous_date == today + 1 # 初回処理
        if memo_date == today || memo_date == today - 1 # 今日か昨日の場合
          streak_count += 1
        else
          return 0
        end
      elsif memo_date == previous_date - 1 # 連続している場合
        streak_count += 1
      else
        break
      end

      previous_date = memo_date
    end
    streak_count
  end

  ### 今日のメモが存在するか？ ###
  def self.today_memo?(user)
    user.memos.exists?(created_at: Date.today.all_day)
  end

  ### プレースホルダー ###
  def self.placeholders
    {
      happy: {
        what: "嬉しいことがあった？ どんなこと？",
        why: "どうして嬉しかったんだろう？",
        why_more: "なぜ(why) のどんなところが嬉しいんだろう？ もう少し詳しく！",
        how: "そう感じて何かアクションをした？これからどうする？",
        summary: "この出来事への気付きを、自分の言葉で整理してみよう!"
      },
      angry: {
        what: "イラッとしたことがあった？　どんなこと？",
        why: "どうしてイラッとしたんだろう？",
        why_more: "なぜ(why) のどんなところにイラッとするんだろう？ もう少し詳しく！",
        how: "そう感じて何かアクションをした？これからどうする？",
        summary: "この出来事への気付きを、自分の言葉で整理してみよう!"
      },
      sad: {
        what: "悲しかったこと・寂しかったことがあった？　どんなこと？",
        why: "どうして悲しかった/どうして寂しかったんだろう？",
        why_more: "なぜ(why) のどんなところに悲しさ/寂しさを感じるんだろう？ もう少し詳しく！",
        how: "そう感じて何かアクションをした？これからどうする？",
        summary: "この出来事への気付きを、自分の言葉で整理してみよう!"
      },
      funny: {
        what: "楽しかったこと・面白かったことがあった？　どんなこと？",
        why: "どうして楽しかった/どうして面白かったんだろう？",
        why_more: "なぜ(why) のどんなところに楽しさ/面白さを感じるんだろう？ もう少し詳しく！",
        how: "そう感じて何かアクションをした？これからどうする？",
        summary: "この出来事への気付きを、自分の言葉で整理してみよう!"
      },
      other: {
        what: "どんなことがあったの？",
        why: "どうしてそう感じたんだろう？",
        why_more: "どうしてそう感じたんだろう？　もう少し詳しく！",
        how: "そう感じて何かアクションをした？これからどうする？",
        summary: "この出来事への気付きを、自分の言葉で整理してみよう!"
      }
    }
  end

  ### 感情別のプレースホルダーを返す ###
  def placeholder_for_all(key, emotion)
    placeholders = Memo.placeholders
    emotion = emotion&.to_sym
    key = key.to_sym  # keyをシンボルに変換

    placeholders.dig(emotion, key)
  end
end
