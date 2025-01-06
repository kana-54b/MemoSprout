require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MemoSprout
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Rails7.2現在　to_timeメソッドの動作を指定。将来的なRailsの挙動変更に対する対応。
    config.active_support.to_time_preserves_timezone = :offset
    # 将来のRails 8.1の挙動に合わせる場合は以下を使用
    # config.active_support.to_time_preserves_timezone = :zone

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # アプリ全体でのデフォルトタイムゾーンを東京に設定
    config.time_zone = "Asia/Tokyo"

    # データベースのタイムゾーンを東京に設定
    config.active_record.default_timezone = :local

    # config.eager_load_paths << Rails.root.join("extras")

    # I18nライブラリに訳文の探索場所を指示する
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}").to_s]
    # ロケールの設定
    config.i18n.default_locale = :ja
  end
end
