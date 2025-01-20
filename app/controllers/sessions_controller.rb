class SessionsController < ApplicationController
  skip_before_action :authenticate

  def create
    if (user = User.find_or_create_from_auth_hash(auth_hash))
      log_in user
    end
    redirect_to cards_path, notice: 'ログインしました'
  end

  def destroy
    log_out
    redirect_to home_index_path, notice: 'ログアウトしました'
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
