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
    Rails.logger.debug("DEBUG: streak_daysがよばれました。このユーザーに: #{user.id}")

    # メモの作成日を取得し日時を日付に変換、日付の重複を削除。
    dates = user.memos.order(created_at: :asc).pluck(:created_at).map(&:to_date).uniq
    Rails.logger.debug("dates📅: #{dates} - USER👦: #{user.id}")

    streak_count = 1 # 連続記録をカウントする
    previous_date = nil # 直前の日付を保持する

    dates.each do |date|
      current_date = date
      Rails.logger.debug("current_date🍎: #{current_date}, previous_date🍏: #{previous_date}, streak_count#️⃣: #{streak_count}")

    if previous_date.nil? || current_date == previous_date + 1 # 直前の日付がnilの場合、または今日の日付が直前の日付+1の場合
      streak_count += 1 unless previous_date.nil? # 直前の日付がnilではない時（直前の日付が入っている時）に、streak_countを+1する
    elsif current_date > previous_date + 1 # 今日の日付が直前の日付+1よりも大きい場合(1日より空いている場合)
      Rails.logger.debug "🐛:日付が空いたため中断" 
      break # ループを抜ける
    end

      previous_date = current_date # 直前の日付 ＝　今日の日付に更新
    end

    Rails.logger.debug "DEBUG🔥: 最終的なstreak_count: #{streak_count}"
    streak_count # 計算結果を返す
  end
end
