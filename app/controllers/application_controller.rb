class ApplicationController < ActionController::Base
  before_action :require_login

  add_flash_types :info, :success, :warning, :error

  private

  def not_authenticated; end
end
