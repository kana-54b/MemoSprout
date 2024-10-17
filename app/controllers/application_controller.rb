class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :require_login

  private

  def not_authenticated; end
end
