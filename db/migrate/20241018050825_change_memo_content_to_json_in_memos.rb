class ChangeMemoContentToJsonInMemos < ActiveRecord::Migration[7.2]
  def up
    change_column :memos, :memo_content, :jsonb, using: 'memo_content::jsonb', null: false
  end

  def down
    change_column :memos, :memo_content, :text
  end
end
