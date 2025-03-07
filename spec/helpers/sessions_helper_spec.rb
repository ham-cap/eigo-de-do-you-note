require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  let(:user) { FactoryBot.create(:user) }
  describe '#current_user' do
    it 'returns a user when the user has logged in' do
      log_in(user)
      expect(helper.current_user).to eq(user)
    end

    it 'returns nil when a user doesn\'t log in' do
      log_out
      expect(helper.current_user).to eq(nil)
    end
  end

  describe '#log_in' do
    it 'returns session when a user log in' do
      expect(helper.log_in(user)).to eq(user.id)
    end
  end

  describe '#log_out' do
    it 'returns nil when a user log out' do
      log_in(user)
      expect(helper.log_out).to eq(nil)
    end
  end
end
