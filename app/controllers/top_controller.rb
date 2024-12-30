class TopController < ApplicationController
  skip_before_action :require_login

  def index; end

  def privacy_policy
    render "shared/privacy_policy"
  end

  def terms_of_service
    render "shared/terms_of_service"
  end
end
