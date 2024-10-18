class ChangeMemoContentToJsonInMemos < ActiveRecord::Migration[7.2]
  def change
    change_column :memos, :memo_content, :jsonb, using: 'memo_content::jsonb', null: false
  end
end
