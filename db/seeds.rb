# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# ※create seed file
# load(Rails.root.join("親ディレクトリ", "子ディレクトリ", "#{開発環境名.downcase}.rb)) 環境ごとに異なるデータをが必要な場合に使用
load(Rails.root.join("db", "seeds", "#{Rails.env.downcase}.rb"))
