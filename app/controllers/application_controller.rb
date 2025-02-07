class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :authenticate

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  private

  def logged_in?
    !!current_user
  end

  def authenticate
    return if logged_in?
    redirect_to root_path, alert: 'ログインしてください'
  end
end
