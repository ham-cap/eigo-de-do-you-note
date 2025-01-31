class HomeController < ApplicationController
  skip_before_action :authenticate
  def index
  end

  def terms
  end

  def privacy
  end
end
