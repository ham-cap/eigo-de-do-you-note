require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe '.find_or_new_auth_hash' do
    it 'returns the stored user if the user already exists' do
      auth_hash = { info: { name: user.name, email: user.email, image: user.image }, uid: user.uid, provider: user.provider }
      expect(User.find_or_new_from_auth_hash(auth_hash)).to eq user
    end

    it 'returns the built user if the user doesn\'t exist' do
      new_auth_hash = { info: { name: 'New User', email: 'new_user@example.com', image: '/app/assets/images/default_user_icon' }, uid: SecureRandom.uuid, provider: 'google_oauth2' }
      new_user = User.find_or_new_from_auth_hash(new_auth_hash)
      expect(new_user).to be_a_new(User)
    end
  end
end
