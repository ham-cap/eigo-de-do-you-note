class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :check_logged_in

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def check_logged_in
    return if current_user
    redirect_to home_index_path
  end
end
