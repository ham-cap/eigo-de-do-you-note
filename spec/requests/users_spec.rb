require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe 'DELETE /user' do
    it 'allows a logged-in user to withdraw' do
      user = create(:user)

      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: user.provider,
        uid: user.uid,
        info: { name: user.name, email: user.email, image: user.image }
      })

      get '/auth/google_oauth2/callback'
      expect(response).to redirect_to(cards_path)

      expect {
        delete user_path
      }.to change { User.count }.by(-1)

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('退会しました')
    end

    it 'redirects to root if not logged in' do
      delete user_path

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('ログインしてください')
    end
  end
end
