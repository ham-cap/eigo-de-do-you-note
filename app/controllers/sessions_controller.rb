class SessionsController < ApplicationController
  skip_before_action :authenticate

  def create
    user = User.find_or_new_from_auth_hash(auth_hash)
    if user.save
      log_in user
      redirect_to cards_path, notice: 'ログインしました'
    else
      redirect_to root_path, alert: 'ログインに失敗しました'
    end
  end

  def destroy
    log_out
    redirect_to root_path, notice: 'ログアウトしました'
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
