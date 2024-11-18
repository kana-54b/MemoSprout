class Memo < ApplicationRecord
  belongs_to :user
  has_one :memo_favorite, dependent: :destroy

  validates :memo_content, presence: true
  validate :validate_memo_content

  def validate_memo_content
    # memo_contentがJSON形式であることを前提にデータを取得
    data = JSON.parse(memo_content) rescue {}

    if data["what"].blank? || data["why"].blank? || data["why_more"].blank? || data["how"].blank? || data["summary"].blank?
      errors.add(:base, "(*)は必須項目です")
    end
  end

  def memo_content=(value) # memo_contentデータの作成前にJSON形式に変換
    if value.is_a?(Hash)
      super(value.to_json)
    else
      super
    end
  end

  def favorited_by?(user) # current_userがお気に入り登録しているかを確認
    memo_favorite&.user_id == user.id
  end

  def self.streak_days(user) # 連続記録
    today = Date.today
    streak_count = 0 # 連続記録をカウントする
    previous_date = nil # 直前の日付を保持する

    Rails.logger.debug("今日🌞: #{today.all_day}")

    # 今日のメモだけでなく、過去のメモを全て取得する
    user.memos.where("created_at <= ?", today.end_of_day).order(created_at: :desc).each do |memo|
      memo_date = memo.created_at.to_date # メモの日付を取得。時刻は除く。
      Rails.logger.debug("取得したメモの作成日📝: #{memo_date}")
      Rails.logger.debug("直前の日付👀: #{previous_date}")

      if previous_date.nil? # 直前の日付がnilの場合
        streak_count = 1
        Rails.logger.debug("初回処理 memo_date📕: #{memo_date}")
        Rails.logger.debug("初回処理 streak_count📕: #{streak_count}")
      elsif memo_date == previous_date # 直前の日付と同じ場合
        Rails.logger.debug("🔁: 重複した日付: #{memo_date} はスキップ")
      elsif memo_date == previous_date - 1 # 連続している場合
        streak_count += 1
        Rails.logger.debug("連続記録🔥: #{streak_count}")
      else
        Rails.logger.debug("途切れた日付🐛: #{memo_date}で記録終了")
        break
      end

      previous_date = memo_date
      Rails.logger.debug("previous_dateを更新📅: #{previous_date} = #{memo_date}")

      if previous_date.nil?
        streak_count = 1 # 初回処理の場合
      elsif previous_date == memo_date || previous_date == memo_date - 1 # 直前の日付と同じか、連続している場合
        # 何もしない（streak_countをそのままにする）
      else
        streak_count = 0
      end
    end

    Rails.logger.debug("最終連続の記録streak_count🔵: #{streak_count}")
    streak_count
  end
end
