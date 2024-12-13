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
end
