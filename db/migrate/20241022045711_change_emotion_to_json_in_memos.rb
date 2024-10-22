class ChangeEmotionToJsonInMemos < ActiveRecord::Migration[7.2]
  def up
    change_column :memos, :emotion, :jsonb, using: 'emotion::jsonb'
  end

  def down
    change_column :memos, :emotion, :text
  end
end
