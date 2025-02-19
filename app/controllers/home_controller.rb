class HomeController < ApplicationController
  skip_before_action :authenticate
  def index
    redirect_to cards_path if current_user.present?
  end

  def terms
  end

  def privacy
  end
end
