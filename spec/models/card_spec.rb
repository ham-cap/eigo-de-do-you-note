require 'rails_helper'

RSpec.describe Card, type: :model do
  it 'can have cards with the same content between different users' do
    user1 = FactoryBot.build(:user)
    user2 = FactoryBot.build(:user)
    card1 = FactoryBot.create(:card, user: user1)
    card2 = FactoryBot.build(:card, :has_the_same_combination, user: user2)
    card2.valid?
    expect(card2.errors[:ja_phrase]).not_to include('このフレーズはすでに存在します。')
  end

  it 'must have Japanese or English phrase when a user submits a creation form' do
    user = FactoryBot.build(:user)
    card = FactoryBot.build(:card, :without_any_phrases, user: user)
    card.valid?
    expect(card.errors[:base]).to include('フレーズを入力してください。')
  end
end
